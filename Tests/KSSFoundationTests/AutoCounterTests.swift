//
//  AutoCounterTests.swift
//
//  Created by Steven W. Klassen on 2020-02-25.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSFoundation


class AutoCounterTests: XCTestCase {

    func testBasicUsage() {
        let autoInt = AutoCounter()
        XCTAssertEqual(autoInt.next(), 1)
        XCTAssertEqual(autoInt.next(), 2)
        XCTAssertEqual(autoInt.next(), 3)
    }

}
