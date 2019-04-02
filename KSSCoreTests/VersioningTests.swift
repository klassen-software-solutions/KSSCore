//
//  VersioningTests.swift
//  KSSCoreTests
//
//  Created by Steven W. Klassen on 2019-04-01.
//  Copyright © 2019 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSCore
//@testable import KSSCore

class VersioningTests: XCTestCase {
    func testVersion() {
        XCTAssert(!Versioning.version.isEmpty)
        XCTAssert(!Versioning.license.isEmpty)
        XCTAssert(!Versioning.copyright.isEmpty)
    }
}
