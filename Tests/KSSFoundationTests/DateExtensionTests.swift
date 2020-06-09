//
//  DateExtensionTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-06-09.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation
import XCTest
import KSSFoundation

class DateExtensionTests: XCTestCase {
    func testDescriptionInTimeZone() {
        let d = Date(timeIntervalSince1970: 1591716802.6589699)
        XCTAssertNotEqual(d.description(inTimeZone: .current).count, 0)
        if let tz = TimeZone(identifier: "Asia/Jerusalem") {
            XCTAssertEqual(d.description(inTimeZone: tz), "2020-06-09 18:33:22 GMT+3")
        }
        if let tz = TimeZone(identifier: "America/Edmonton") {
            XCTAssertEqual(d.description(inTimeZone: tz), "2020-06-09 09:33:22 MDT")
        }
    }
}
