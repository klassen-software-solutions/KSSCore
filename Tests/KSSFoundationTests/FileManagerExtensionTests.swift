//
//  FileManagerExtensionTests.swift
//
//  Created by Steven W. Klassen on 2020-02-28.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation
import XCTest
import KSSFoundation

class FileManagerExtensionTests: XCTestCase {
    let fm = FileManager.default

    func testDirectoryExists() {
        XCTAssertFalse(fm.directoryExists(atPath: "nosuchdirectory"))
        XCTAssertTrue(fm.directoryExists(atPath: "."))

        XCTAssertFalse(fm.directoryExists(at: URL(string: "nosuchdirectory")!))
        XCTAssertTrue(fm.directoryExists(at: URL(string: ".")!))
    }

    @available(OSX 10.12, *)
    func testCreateTemporaryDirectory() {
        let url = try? fm.createTemporaryDirectory()
        XCTAssertNotNil(url)
        XCTAssertTrue(fm.directoryExists(atPath: url!.path))
        try? fm.removeItem(at: url!)
    }
}
