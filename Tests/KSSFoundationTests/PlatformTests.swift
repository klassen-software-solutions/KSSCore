//
//  PlatformTests.swift
//  
//
//  Created by Steven W. Klassen on 2021-05-21.
//

import Foundation
import XCTest

import KSSTest

import KSSFoundation


class PlatformTests: XCTestCase {
    func testOperatingSystem() throws {
        #if os(macOS)
        assertEqual(to: "macOS") { Platform.operatingSystem }
        #elseif os(Linux)
        assertEqual(to: "Linux") { Platform.operatingSystem }
        #else
        assertNotNil { Platform.operatingSystem }
        #endif
    }

    func testOperatingSystemVersion() throws {
        assertNotNil { Platform.operatingSystemVersion }
    }

    func testHardware() throws {
        #if arch(x86_64)
        assertEqual(to: "x86_64") { Platform.hardware }
        #else
        assertNotNil { Platform.hardware }
        #endif
    }
}
