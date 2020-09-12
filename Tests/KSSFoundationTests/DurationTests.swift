//
//  DurationTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-06-09.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation
import KSSTest
import XCTest
import KSSFoundation

class DurationTests: XCTestCase {
    func testUnitaryValues() {
        assertEqual(to: 1.0) { duration(1, .seconds) }
        assertEqual(to: 60.0) { duration(1.0, .minutes) }
        assertEqual(to: 3600.0) { duration(1.0, .hours) }
        assertEqual(to: 86400.0) { duration(1.0, .days) }
        assertEqual(to: duration(1.0, .weeks)) { duration(7, .days) }
        assertEqual(to: duration(1.0, .months)) { duration(30.0, .days) }
        assertEqual(to: duration(1.0, .years)) { duration(365, .days) }
        assertEqual(to: -60.0) { duration(-1.0, .minutes) }
    }

    func testMultiples() {
        assertEqual(to: 300.0) { duration(5.0, .minutes) }
        assertEqual(to: 315360000.0) { duration(10.0, .years) }
        assertEqual(to: 6307200.0) { duration(0.2, .years) }
    }

    func testCalendarBasedDuration() {
        let startDate = Date(timeIntervalSince1970: 1591716802.6589699)

        assertEqual(to: 5.0) { duration(5, .seconds, from: startDate) }
        assertEqual(to: 300.0) { duration(5, .minutes, from: startDate) }
        assertEqual(to: 18000.0) { duration(5, .hours, from: startDate) }
        assertEqual(to: 432000.0) { duration(5, .days, from: startDate) }
        assertEqual(to: 3024000.0) { duration(5, .weeks, from: startDate) }
        assertEqual(to: 13222800.0) { duration(5, .months, from: startDate) }
        assertEqual(to: 157766400.0) { duration(5, .years, from: startDate) }
        assertEqual(to: -300.0) { duration(-5, .minutes, from: startDate) }
    }
}
