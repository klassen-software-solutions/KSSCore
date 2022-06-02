//
//  String+rangeTests.swift
//  
//
//  Created by Steven W. Klassen on 2022-06-02.
//

import Foundation


import XCTest
import KSSFoundation


class StringExtensionRangeTests: XCTestCase {

    func testRange() throws {
        XCTAssertEqual(String().range, NSRange(location: 0, length: 0))
        XCTAssertEqual("".range, NSRange(location: 0, length: 0))
        XCTAssertEqual("hello world".range, NSRange(location: 0, length: 11))
    }
}
