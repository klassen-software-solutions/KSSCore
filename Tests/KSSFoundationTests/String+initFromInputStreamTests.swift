//
//  String+initFromInputStreamTests.swift
//
//  Created by Steven W. Klassen on 2020-02-28.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSFoundation


class StringExtensionInitFromInputStreamTests: XCTestCase {

    func testInitFromContentsOfStream() throws {
        var inStream = InputStream(data: "Hello World".data(using: .utf8)!)
        XCTAssertEqual(String(contentsOfStream: inStream, encoding: .utf8), "Hello World")

        inStream = InputStream(data: "This should not decode in UTF-32".data(using: .utf8)!)
        XCTAssertNil(String(contentsOfStream: inStream, encoding: .utf32))

        inStream = BadInputStream()
        XCTAssertNil(String(contentsOfStream: inStream, encoding: .utf8))
    }
}


fileprivate class BadInputStream : InputStream {
    init() {
        super.init(data: Data())
    }

    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        return -1
    }

    override var hasBytesAvailable: Bool { true }
    override var streamError: Error? { NSError(domain: "hi", code: 1, userInfo: nil) }

    override func open() {}
    override func close() {}
}
