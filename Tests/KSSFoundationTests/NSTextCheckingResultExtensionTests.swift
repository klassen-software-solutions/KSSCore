//
//  NSTextCheckingResultExtensionTests.swift
//  WSTerminalTests
//
//  Created by Steven W. Klassen on 2020-06-16.
//  Copyright © 2020 Ebed Technologies Ltd. All rights reserved.
//

import XCTest

class NSTextCheckingResultExtensionTests: XCTestCase {

    func testCapture() throws {
        let s = "1.2.3-1-g565c893M (4)"
        var regex = try! NSRegularExpression(pattern: "^(\\d+).*$")
        var match = regex.firstMatch(in: s, range: s.range)!
        XCTAssertEqual(String(match.capture(at: 0, in: s)!), s)
        XCTAssertEqual(String(match.capture(at: 1, in: s)!), "1")
        XCTAssertNil(match.capture(at: 2, in: s))

        regex = try! NSRegularExpression(pattern: "^(\\d+)\\.?(\\d+)?.*$")
        match = regex.firstMatch(in: s, range: s.range)!
        XCTAssertEqual(String(match.capture(at: 0, in: s)!), s)
        XCTAssertEqual(match.capture(at: 1, in: s), "1")
        XCTAssertEqual(match.capture(at: 2, in: s), "2")
        XCTAssertNil(match.capture(at: 3, in: s))

        regex = try! NSRegularExpression(pattern: "^(\\d+)\\.?(\\d+)?\\.?(\\d+)?.*$")
        match = regex.firstMatch(in: s, range: s.range)!
        XCTAssertEqual(String(match.capture(at: 0, in: s)!), s)
        XCTAssertEqual(String(match.capture(at: 1, in: s)!), "1")
        XCTAssertEqual(String(match.capture(at: 2, in: s)!), "2")
        XCTAssertEqual(String(match.capture(at: 3, in: s)!), "3")
        XCTAssertNil(match.capture(at: 4, in: s))

        regex = try! NSRegularExpression(pattern: "^(\\d+)\\.?(\\d+)?\\.?(\\d+)?([\\S]+)?.*$")
        match = regex.firstMatch(in: s, range: s.range)!
        XCTAssertEqual(String(match.capture(at: 0, in: s)!), s)
        XCTAssertEqual(String(match.capture(at: 1, in: s)!), "1")
        XCTAssertEqual(String(match.capture(at: 2, in: s)!), "2")
        XCTAssertEqual(String(match.capture(at: 3, in: s)!), "3")
        XCTAssertEqual(String(match.capture(at: 4, in: s)!), "-1-g565c893M")
        XCTAssertNil(match.capture(at: 5, in: s))

        regex = try! NSRegularExpression(pattern: "^(\\d+)\\.?(\\d+)?\\.?(\\d+)?([\\S]+)?\\s?\\(?(\\d+)?\\)?.*$")
        match = regex.firstMatch(in: s, range: s.range)!
        XCTAssertEqual(String(match.capture(at: 0, in: s)!), s)
        XCTAssertEqual(String(match.capture(at: 1, in: s)!), "1")
        XCTAssertEqual(String(match.capture(at: 2, in: s)!), "2")
        XCTAssertEqual(String(match.capture(at: 3, in: s)!), "3")
        XCTAssertEqual(String(match.capture(at: 4, in: s)!), "-1-g565c893M")
        XCTAssertEqual(String(match.capture(at: 5, in: s)!), "4")
        XCTAssertNil(match.capture(at: 6, in: s))

    }

    func testCaptureWithPartialMatch() throws {
        let s = "1.2"
        let regex = try! NSRegularExpression(pattern: "^(\\d+)\\.?(\\d+)?\\.?(\\d+)?([\\S]+)?\\s?\\(?(\\d+)?\\)?$")
        let match = regex.firstMatch(in: s, range: s.range)!
        XCTAssertEqual(String(match.capture(at: 0, in: s)!), s)
        XCTAssertEqual(String(match.capture(at: 1, in: s)!), "1")
        XCTAssertEqual(String(match.capture(at: 2, in: s)!), "2")
        XCTAssertNil(match.capture(at: 3, in: s))
        XCTAssertNil(match.capture(at: 4, in: s))
    }
}
