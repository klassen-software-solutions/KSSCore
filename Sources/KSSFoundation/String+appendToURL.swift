//
//  String+appendToURL.swift
//  
//
//  Created by Steven W. Klassen on 2022-06-02.
//

import Foundation

#if canImport(os)
    import os
#endif


public extension String {

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
                os_log("Could not convert string to UTF8 data")
            }
        } else {
            try self.write(to: url, atomically: true, encoding: .utf8)
        }
    }
}

