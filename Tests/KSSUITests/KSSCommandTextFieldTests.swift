//
//  KSSCommandTextFieldTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-05.
//  Released under the MIT license.
//

import Foundation
import SwiftUI
import XCTest

@testable import KSSUI


@available(OSX 10.15, *)
class KSSCommandTextFieldTests: XCTestCase {
    struct TestThatItCompilesInAView : View {
        @State private var command: String = ""

        var body: some View {
            VStack {
                KSSCommandTextField(command: $command)
                KSSCommandTextField(command: $command, helpText: "message to send")
                    .errorHighlight(NSColor.green)
                    .validator { _ in return false }
                    .nsFont(NSFont.systemFont(ofSize: 10))
                    .nsFontSize(12)
            }
        }
    }


    func testConstruction() {
        var commandField = KSSCommandTextField(command: .constant("hi"))
        XCTAssertEqual(commandField.command, "hi")
        XCTAssertEqual(commandField.helpText, "command")
        XCTAssertNil(commandField.validatorFn)
        XCTAssertEqual(commandField.errorHighlightColor, NSColor.errorHighlightColor)

        commandField = KSSCommandTextField(command: .constant("hi"), helpText: "help")
        XCTAssertEqual(commandField.command, "hi")
        XCTAssertEqual(commandField.helpText, "help")
        XCTAssertNil(commandField.validatorFn)
        XCTAssertEqual(commandField.errorHighlightColor, NSColor.errorHighlightColor)
    }

    func testModifiers() {
        let commandField = KSSCommandTextField(command: .constant("hi"))
            .errorHighlight(NSColor.red)
            .validator { _ in return true }
        XCTAssertEqual(commandField.errorHighlightColor, NSColor.red)
        XCTAssertNotNil(commandField.validatorFn)
    }

    func testNSCommandModifiers() {
        var commandField = KSSCommandTextField(command: .constant("hi"))
        XCTAssertNil(commandField.nsControlViewSettings.font)
        XCTAssertNil(commandField.nsControlViewSettings.fontSize)

        commandField = commandField.nsFont(NSFont.boldSystemFont(ofSize: 10))
        XCTAssertNotNil(commandField.nsControlViewSettings.font)
        XCTAssertNil(commandField.nsControlViewSettings.fontSize)

        commandField = commandField.nsFontSize(10)
        XCTAssertNotNil(commandField.nsControlViewSettings.font)
        XCTAssertEqual(commandField.nsControlViewSettings.fontSize, 10)
    }
}
