//
//  KSSURLTextFieldTests.swift
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
class KSSURLTextFieldTests: XCTestCase {
    struct TestThatItCompilesInAView : View {
        @State var url: URL? = nil

        var body: some View {
            VStack {
                KSSURLTextField(url: $url)
                KSSURLTextField(url: $url, helpText: "help")
                    .errorHighlight(Color.green)
                    .validator { _ in return false }
            }
        }
    }


    func testConstruction() {
#if canImport(Cocoa)
        let correctColor = Color(NSColor.errorHighlightColor)
#else
        let correctColor = Color.yellow.opacity(0.5)
#endif

        var control = KSSURLTextField(url: .constant(nil))
        XCTAssertEqual(control.helpText, "url")
        XCTAssertNil(control.validatorFn)
        XCTAssertEqual(control.errorHighlightColor, correctColor)

        control = KSSURLTextField(url: .constant(nil), helpText: "help")
        XCTAssertEqual(control.helpText, "help")
        XCTAssertNil(control.validatorFn)
        XCTAssertEqual(control.errorHighlightColor, correctColor)
    }

    func testModifiers() {
        let control = KSSURLTextField(url: .constant(nil))
            .errorHighlight(Color.red)
            .validator { _ in return true }
        XCTAssertEqual(control.errorHighlightColor, Color.red)
        XCTAssertNotNil(control.validatorFn)
    }
}
