//
//  StringExtension.swift
//
//  Created by Steven W. Klassen on 2020-02-28.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation

#if canImport(os)
    import os
#endif
#if canImport(FoundationXML)
    import FoundationXML
#endif


public extension String {

    /**
     The full range of the string.
     */
    var range: NSRange { NSRange(self.startIndex..., in: self) }

    /**
     Create a string given the contents of an input stream and its encoding. Note that this will
     return `nil` if there is an error either in reading from the stream or in the data decoding.
     */
    init?(contentsOfStream stream: InputStream, encoding: String.Encoding) {
        if let data = try? Data(fromInputStream: stream) {
            self.init(data: data, encoding: encoding)
        } else {
            return nil
        }
    }

    /**
     Appends the string to the end of the file specified by `url`. This version automatically adds
     a newline after the string.
     */
    func appendLine(to url: URL) throws {
        try self.appending("\n").append(to: url)
    }

    /**
     Appends the string to the end of the file specified by `url`. This version does not add
     a newline after the string.
     */
    func append(to url: URL) throws {
        if let file = try? FileHandle(forWritingTo: url) {
            defer { file.closeFile() }
            file.seekToEndOfFile()
            if let data = self.data(using: .utf8) {
                file.write(data)
            } else {
#if canImport(os)
                if #available(OSX 10.14, *) {
                    os_log(.error, "Could not convert string to UTF8 data")
                } else {
                    // Will quietly ignore the problem on older OS versions.
                }
#endif
            }
        } else {
            try self.write(to: url, atomically: true, encoding: .utf8)
        }
    }

    /**
     If the string is recognized as something that can be pretty-printed, the result
     will be returned. Otherwise, if not recognized, we return ourself. Currently this will
     recognize and pretty print JSON and XML text.

     - note: The XML handling is only available in OSX 10.14 or later
     */
    @available(OSX 10.13, *)
    func prettyPrint() -> String {
        if let asJson = prettyPrintJSON() {
            return asJson
        }
        if #available(OSX 10.14, *) {
            if let asXml = prettyPrintXML() {
                return asXml
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }

    @available(OSX 10.13, *)
    private func prettyPrintJSON() -> String? {
        do {
            if let data = self.data(using: .utf8) {
                let obj = try JSONSerialization.jsonObject(with: data)
                let newData = try JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys])
                if let newStr = String(data: newData, encoding: .utf8) {
                    return newStr
                }
            }
        } catch {
            // Intentionally empty
        }
        return nil
    }

    @available(OSX 10.14, *)
    private func prettyPrintXML() -> String? {
        do {
            let doc = try XMLDocument(xmlString: self)
#if os(Linux)
            // The Linux version does not currently handle invalid XML properly. However,
            // we can check for this by seeing if the root element is nil. This has been
            // reported at https://bugs.swift.org/browse/SR-13191.
            if doc.rootElement() == nil {
                return nil
            }

            // The Linux version also does not handle text where the encoding has not
            // been set. So we check for that and set it to a default of utf-8. This is
            // also a part of https://bugs.swift.org/browse/SR-13191.
            let encoding = (contains("encoding=") ? getEncoding(fromXml: doc) : .utf8)

            // Finally, the Linux version will not handle any encoding other than utf-8.
            // (It is listed as unfinished as of Swift 5.2.4.) So if we are attempting
            // something other than utf-8, we will not pretty print the result.
            if encoding != .utf8 {
                return nil
            }
#else
            let encoding = getEncoding(fromXml: doc)
#endif
            let newData = doc.xmlData(options: [.nodePrettyPrint])
            if let newStr = String(data: newData, encoding: encoding) {
                return newStr
            }
        } catch {
            // Intentionally empty
        }
        return nil
    }

    // These encodings are based on the the following site:
    // https://www.iana.org/assignments/character-sets/character-sets.xhtml
    @available(OSX 10.14, *)
    private func getEncoding(fromXml doc: XMLDocument) -> String.Encoding {
        let encodingString = doc.characterEncoding ?? "UTF-8"
        switch encodingString {
        case "UTF-8", "csUTF8":
            return .utf8
        case "UTF-16", "csUTF16":
            return .utf16
        case "UTF-32", "csUTF32":
            return .utf32
        case "US-ASCII", "iso-ir-6", "ANSI_X3.4-1968", "ANSI_X3.4-1986", "ISO_646.irv:1991",
             "ISO646-US", "us", "IBM367", "cp367", "csASCII":
            return .ascii
        case "ISO-2022-JP", "csISO2022JP":
            return .iso2022JP
        case "iso-ir-100", "ISO_8859-1", "ISO-8859-1", "latin1", "l1", "IBM819",
             "CP819", "csISOLatin1":
            return .isoLatin1
        case "iso-ir-101", "ISO_8859-2", "ISO-8859-2", "latin2", "l2", "csISOLatin2":
            return .isoLatin2
        case "csEUCPkdFmtJapanese", "EUC-JP":
            return .japaneseEUC
        case "macintosh", "mac", "csMacintosh":
            return .macOSRoman
        case "Shift_JIS", "MS_Kanji", "csShiftJIS":
            return .shiftJIS
        case "ISO-10646-UCS-2", "csUnicode":
            return .unicode
        case "UTF-16BE", "csUTF16BE":
            return .utf16BigEndian
        case "UTF-16LE", "csUTF16LE":
            return .utf16LittleEndian
        case "UTF-32BE", "csUTF32BE":
            return .utf32BigEndian
        case "UTF-32LE", "csUTF32LE":
            return .utf32LittleEndian
        case "windows-1250", "cswindows1250":
            return .windowsCP1250
        case "windows-1251", "cswindows1251":
            return .windowsCP1251
        case "windows-1252", "cswindows1252":
            return .windowsCP1252
        case "windows-1253", "cswindows1253":
            return .windowsCP1253
        case "windows-1254", "cswindows1254":
            return .windowsCP1254
        default:
            // Hope for the best
#if canImport(os)
            os_log(.error, "Could not recognize encoding of '%s', will try using UTF-8", encodingString)
#else
            // Will quietly ignore the problem.
#endif
            return .utf8
        }
    }

}
