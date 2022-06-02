//
//  String+prettyPrintTests.swift
//  
//
//  Created by Steven W. Klassen on 2022-06-02.
//

import XCTest
import KSSFoundation


class StringExtensionPrettyPrintTests: XCTestCase {
    
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

    let exampleWithSlash = "{ \"url\": \"http://localhost:8080/hi\" }"

    @available(OSX 10.14, *)
    func testBug60PrettyPrintEscapes() {
        print(exampleWithSlash.prettyPrint())
    }

}
