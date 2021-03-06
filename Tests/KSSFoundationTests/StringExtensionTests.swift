//
//  StringExtensionTests.swift
//
//  Created by Steven W. Klassen on 2020-02-28.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSFoundation


class StringExtensionTests: XCTestCase {

    let fileManager = FileManager.default
    var directory: URL? = nil

    func readFile(_ url: URL) -> String {
        return (try? String(contentsOf: url, encoding: .utf8)) ?? ""
    }

    override func setUp() {
        directory = try! fileManager.createTemporaryDirectory()
    }

    override func tearDown() {
        try! fileManager.removeItem(at: directory!)
    }

    func testInitFromContentsOfStream() throws {
        var inStream = InputStream(data: "Hello World".data(using: .utf8)!)
        XCTAssertEqual(String(contentsOfStream: inStream, encoding: .utf8), "Hello World")

        inStream = InputStream(data: "This should not decode in UTF-32".data(using: .utf8)!)
        XCTAssertNil(String(contentsOfStream: inStream, encoding: .utf32))

        inStream = BadInputStream()
        XCTAssertNil(String(contentsOfStream: inStream, encoding: .utf8))
    }

    func testRange() throws {
        XCTAssertEqual(String().range, NSRange(location: 0, length: 0))
        XCTAssertEqual("".range, NSRange(location: 0, length: 0))
        XCTAssertEqual("hello world".range, NSRange(location: 0, length: 11))
    }

    func testAppendLine() {
        let file = directory!.appendingPathComponent("testAppendLine", isDirectory: false)
        try! "hello".appendLine(to: file)
        XCTAssertEqual(readFile(file), "hello\n")
        try! "world".appendLine(to: file)
        XCTAssertEqual(readFile(file), "hello\nworld\n")
    }

    func testAppend() {
        let file = directory!.appendingPathComponent("testAppendLine", isDirectory: false)
        try! "hello".append(to: file)
        XCTAssertEqual(readFile(file), "hello")
        try! "world".append(to: file)
        XCTAssertEqual(readFile(file), "helloworld")
    }

    let jsonExample = "{ \"one\": 1, \"two\": 2, \"array\": [\"item1\", \"item2\"], \"dict\": { \"hello\": \"world\" } }"
    let jsonCorrectResults = """
        {
          "array" : [
            "item1",
            "item2"
          ],
          "dict" : {
            "hello" : "world"
          },
          "one" : 1,
          "two" : 2
        }
        """

    let xmlExample = "<someTag withAttribute=\"att1\"><innerTag1>content 1</innerTag1><innerTag2 myatt=\"hi\"/></someTag>"
#if os(macOS)
    let xmlCorrectResults = """
        <?xml version="1.0" encoding="UTF-8"?>
        <someTag withAttribute="att1">
            <innerTag1>content 1</innerTag1>
            <innerTag2 myatt="hi"></innerTag2>
        </someTag>
        """
#else
    // The Linux version uses less spacing, adds a newline, and converts UTF-8 to utf-8
    let xmlCorrectResults = """
        <?xml version="1.0" encoding="utf-8"?>
        <someTag withAttribute="att1">
          <innerTag1>content 1</innerTag1>
          <innerTag2 myatt="hi"></innerTag2>
        </someTag>

        """
#endif

    let notPPExample = "this string is not pretty printable"

    @available(OSX 10.14, *)
    func testPrettyPrint() {
        XCTAssertEqual(jsonExample.prettyPrint(), jsonCorrectResults)
#if os(macOS) || os(Linux)
        XCTAssertEqual(xmlExample.prettyPrint(), xmlCorrectResults)
#endif
        XCTAssertEqual(notPPExample.prettyPrint(), notPPExample)

        // Test for bug #30. Pretty printing xmlCorrectResults should produce itself.
        XCTAssertEqual(xmlCorrectResults.prettyPrint(), xmlCorrectResults)
    }

}


fileprivate class BadInputStream : InputStream {
    init() {
        super.init(data: Data())
    }

    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        return -1
    }

    override var hasBytesAvailable: Bool { true }
    override var streamError: Error? { NSError(domain: "hi", code: 1, userInfo: nil) }

    override func open() {}
    override func close() {}
}
