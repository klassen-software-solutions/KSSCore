//
//  DurationTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-06-09.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation
import XCTest
import KSSFoundation

class DurationTests: XCTestCase {
    func testUnitaryValues() {
        XCTAssertEqual(duration(1, .seconds), 1.0)
        XCTAssertEqual(duration(1, .minutes), 60.0)
        XCTAssertEqual(duration(1, .hours), 3600.0)
        XCTAssertEqual(duration(1, .days), 86400.0)
        XCTAssertEqual(duration(1, .weeks), duration(7, .days))
        XCTAssertEqual(duration(1, .months), duration(30, .days))
        XCTAssertEqual(duration(1, .years), duration(365, .days))
    }

    func testMultiples() {
        XCTAssertEqual(duration(5, .minutes), 300.0)
        XCTAssertEqual(duration(10, .years), 315360000.0)
        XCTAssertEqual(duration(0.2, .years), 6307200.0)
    }
}
