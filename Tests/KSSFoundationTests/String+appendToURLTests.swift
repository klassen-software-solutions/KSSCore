//
//  String+appendToURLTests.swift
//  
//
//  Created by Steven W. Klassen on 2022-06-02.
//

import Foundation
import XCTest


class StringExtensionAppendToURLTests: XCTestCase {

    let fileManager = FileManager.default
    var directory: URL? = nil

    func readFile(_ url: URL) -> String {
        return (try? String(contentsOf: url, encoding: .utf8)) ?? ""
    }

    override func setUp() {
        directory = try! fileManager.createTemporaryDirectory()
    }

    override func tearDown() {
        try! fileManager.removeItem(at: directory!)
    }

    func testAppendLine() {
        let file = directory!.appendingPathComponent("testAppendLine", isDirectory: false)
        try! "hello".appendLine(to: file)
        XCTAssertEqual(readFile(file), "hello\n")
        try! "world".appendLine(to: file)
        XCTAssertEqual(readFile(file), "hello\nworld\n")
    }

    func testAppend() {
        let file = directory!.appendingPathComponent("testAppendLine", isDirectory: false)
        try! "hello".append(to: file)
        XCTAssertEqual(readFile(file), "hello")
        try! "world".append(to: file)
        XCTAssertEqual(readFile(file), "helloworld")
    }
}
