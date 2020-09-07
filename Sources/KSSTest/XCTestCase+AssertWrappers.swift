//
//  XCTestCase+AssertWrappers.swift
//  HTTPMonitorTests
//
//  Created by Steven W. Klassen on 2020-08-24.
//  Copyright © 2020 Ebed Technologies Ltd. All rights reserved.
//

import XCTest

// TODO: move this into KSSCore (KSSTest)

// TODO: document this

public extension XCTestCase {

    func assertTrue(file: StaticString = #file, line: UInt = #line, _ expression: () -> Bool) {
        XCTAssertTrue(expression(), file: file, line: line)
    }

    func assertFalse(file: StaticString = #file, line: UInt = #line, _ expression: () -> Bool) {
        XCTAssertFalse(expression(), file: file, line: line)
    }

    func assertEqual<T : Equatable>(to targetValue: T,
                                    file: StaticString = #file,
                                    line: UInt = #line,
                                    _ expression: () -> T)
    {
        XCTAssertEqual(expression(), targetValue, file: file, line: line)
    }

    func assertNotEqual<T : Equatable>(to targetValue: T,
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       _ expression: () -> T)
    {
        XCTAssertNotEqual(expression(), targetValue, file: file, line: line)
    }

    func assertNil(file: StaticString = #file, line: UInt = #line, _ expression: () -> Any?) {
        XCTAssertNil(expression(), file: file, line: line)
    }

    func assertNotNil(file: StaticString = #file, line: UInt = #line, _ expression: () -> Any?) {
        XCTAssertNotNil(expression(), file: file, line: line)
    }

    func assertNoThrow(file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
        XCTAssertNoThrow(try expression(), file: file, line: line)
    }

    // - throws some error
    func assertThrows(file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
        XCTAssertThrowsError(try expression(), file: file, line: line)
    }

    // - throws a specific error type
    func assertThrowsError<ErrorType>(ofType errorType: ErrorType,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      _ expression: () throws -> Void)
    {
        XCTAssertThrowsError(try expression(), file: file, line: line) { error in
            let receivedErrorType = "\(type(of: error))"
            let targetErrorType = "\(errorType)".removingSuffix(".Type")
            if receivedErrorType != targetErrorType {
                let message = "\(receivedErrorType) is not of the requested type \(targetErrorType)"
                XCTFail(message, file: file, line: line)
            }
        }
    }

    // - throws a specific error value
    func assertThrowsError<E : Error>(ofValue targetError: E,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      _ expression: () throws -> Void)
    {
        XCTAssertThrowsError(try expression(), file: file, line: line) { error in
            let receivedErrorType = "\(type(of: error))"
            let targetErrorType = "\(type(of: targetError))"
            if receivedErrorType != targetErrorType {
                let message = "\(receivedErrorType) is not of the requested type \(targetErrorType)"
                XCTFail(message, file: file, line: line)
                return
            }

            let errorValue = "\(error)"
            let targetErrorValue = "\(targetError)"
            if errorValue != targetErrorValue {
                let message = "\(errorValue) is not of the requested value \(targetErrorValue)"
                XCTFail(message, file: file, line: line)
            }
        }
    }
}

fileprivate extension String {
    func removingSuffix(_ suffix: String) -> String {
        guard suffix.count > 0 else {
            return self
        }
        guard self.hasSuffix(suffix) else {
            return self
        }
        return String(self.dropLast(suffix.count))
    }
}
