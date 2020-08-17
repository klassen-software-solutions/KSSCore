//
//  KSSSearchFieldTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-05.
//

import Foundation
import SwiftUI
import XCTest

@testable import KSSUI


@available(OSX 10.15, *)
class KSSSearchFieldTests: XCTestCase {
    struct TestThatItCompilesInAView : View {
        var body: some View {
            VStack {
                KSSSearchField()
                KSSSearchField(helpText: "help", recentSearchesKey: "recentKey") { _ in print("hi") }
                    .nsFont(NSFont.systemFont(ofSize: 10))
                    .nsFontSize(12)
            }
        }
    }

    func testConstruction() {
        var control = KSSSearchField()
        XCTAssertEqual(control.helpText, "")
        XCTAssertEqual(control.recentSearchesKey, "")
        XCTAssertFalse(control.isFilterField)
        XCTAssertNil(control.searchCallback)

        control = KSSSearchField(helpText: "help", recentSearchesKey: "recents") { _ in }
        XCTAssertEqual(control.helpText, "help")
        XCTAssertEqual(control.recentSearchesKey, "recents")
        XCTAssertFalse(control.isFilterField)
        XCTAssertNotNil(control.searchCallback)

        control = KSSSearchField(isFilterField: true)
        XCTAssertEqual(control.helpText, "")
        XCTAssertEqual(control.recentSearchesKey, "")
        XCTAssertTrue(control.isFilterField)
        XCTAssertNil(control.searchCallback)
    }

    func testNSCommandModifiers() {
        var control = KSSSearchField()
        XCTAssertNil(control.nsControlViewSettings.font)
        XCTAssertNil(control.nsControlViewSettings.fontSize)

        control = control.nsFont(NSFont.boldSystemFont(ofSize: 10))
        XCTAssertNotNil(control.nsControlViewSettings.font)
        XCTAssertNil(control.nsControlViewSettings.fontSize)

        control = control.nsFontSize(10)
        XCTAssertNotNil(control.nsControlViewSettings.font)
        XCTAssertEqual(control.nsControlViewSettings.fontSize, 10)
    }
}
