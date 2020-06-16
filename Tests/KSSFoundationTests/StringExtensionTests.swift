//
//  StringExtensionTests.swift
//
//  Created by Steven W. Klassen on 2020-02-28.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSFoundation


@available(OSX 10.12, *)
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
    let xmlCorrectResults = """
        <?xml version="1.0" encoding="UTF-8"?>
        <someTag withAttribute="att1">
            <innerTag1>content 1</innerTag1>
            <innerTag2 myatt="hi"></innerTag2>
        </someTag>
        """

    let notPPExample = "this string is not pretty printable"

    @available(OSX 10.14, *)
    func testPrettyPrint() {
        XCTAssertEqual(jsonExample.prettyPrint(), jsonCorrectResults)
        XCTAssertEqual(xmlExample.prettyPrint(), xmlCorrectResults)
        XCTAssertEqual(notPPExample.prettyPrint(), notPPExample)
    }

}
