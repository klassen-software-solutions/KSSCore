//
//  DataExtensionTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-03-13.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation
import XCTest
import KSSFoundation

class DataExtensionTests: XCTestCase {
    func testInitFromInputStream() {
        let encodedString = "aGVsbG8gd29ybGQK"
        let decodedData = Data(base64Encoded: encodedString)!
        let inStream = InputStream(data: decodedData)
        let outputData = try! Data(fromInputStream: inStream)
        XCTAssertEqual(outputData, decodedData)
        XCTAssertEqual(String(data: outputData, encoding: .utf8)!, "hello world\n")
    }
}
