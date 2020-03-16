//
//  KSSTextViewTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-03-16.
//

import SwiftUI
import XCTest
import KSSUI


@available(OSX 10.15, *)
class KSSTextViewTests: XCTestCase {
    @State private var testMutableAttributedString = NSMutableAttributedString()

    func testConstruction() {
        var view = KSSTextView(text: $testMutableAttributedString)
        XCTAssertTrue(view.isEditable)
        XCTAssertTrue(view.isSearchable)
        XCTAssertFalse(view.isAutoScrollToBottom)

        view = KSSTextView(text: $testMutableAttributedString)
            .editable(false)
            .searchable(false)
            .autoScrollToBottom()
        XCTAssertFalse(view.isEditable)
        XCTAssertFalse(view.isSearchable)
        XCTAssertTrue(view.isAutoScrollToBottom)
    }
}
