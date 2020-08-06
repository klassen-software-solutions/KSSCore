//
//  KSSToggleTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-05.
//

import Foundation
import SwiftUI
import XCTest

import KSSUI


@available(OSX 10.15, *)
class KSSToggleTests : XCTestCase {
    struct TestThatItCompilesInAView : View {
        @State var isOn: Bool = true

        var body: some View {
            VStack {
                KSSToggle("button", isOn: $isOn)
                KSSToggle("button", isOn: $isOn, isBordered: true, toolTip: "hi")
                KSSToggle(withAttributedTitle: NSAttributedString(string: "button"),
                          isOn: $isOn,
                          isBordered: false,
                          toolTip: "hi")
                KSSToggle(withImage: NSImage(),
                          isOn: $isOn,
                          alternateImage: NSImage(),
                          autoInvertImage: false,
                          isBordered: false,
                          toolTip: "hi")
                    .nsFont(NSFont.systemFont(ofSize: 10))
                    .nsFontSize(12)
            }
        }
    }


    func testConstruction() {
        var button = KSSToggle("button", isOn: .constant(true))
        XCTAssertEqual(button.title, "button")
        XCTAssertNil(button.attributedTitle)
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertNil(button.isBordered)
        XCTAssertNil(button.toolTip)
        XCTAssertTrue(button.autoInvertImage)

        button = KSSToggle("button",
                           isOn: .constant(true),
                           isBordered: false,
                           toolTip: "this is a tooltip")
        XCTAssertEqual(button.title, "button")
        XCTAssertNil(button.attributedTitle)
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertFalse(button.isBordered!)
        XCTAssertEqual(button.toolTip, "this is a tooltip")
        XCTAssertTrue(button.autoInvertImage)

        button = KSSToggle(withAttributedTitle: NSAttributedString(string: "button"), isOn: .constant(true))
         XCTAssertNil(button.title)
         XCTAssertEqual(button.attributedTitle, NSAttributedString(string: "button"))
         XCTAssertNil(button.image)
         XCTAssertNil(button.alternateImage)
         XCTAssertNil(button.isBordered)
         XCTAssertNil(button.toolTip)
         XCTAssertTrue(button.autoInvertImage)

        button = KSSToggle(withAttributedTitle: NSAttributedString(string: "button"),
                           isOn: .constant(true),
                           isBordered: false,
                           toolTip: "this is a tooltip")
        XCTAssertNil(button.title)
        XCTAssertEqual(button.attributedTitle, NSAttributedString(string: "button"))
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertFalse(button.isBordered!)
        XCTAssertEqual(button.toolTip, "this is a tooltip")
        XCTAssertTrue(button.autoInvertImage)

        button = KSSToggle(withImage: NSImage(), isOn: .constant(true))
        XCTAssertNil(button.title)
        XCTAssertNil(button.attributedTitle)
        XCTAssertNotNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertNil(button.isBordered)
        XCTAssertNil(button.toolTip)
        XCTAssertTrue(button.autoInvertImage)

        button = KSSToggle(withImage: NSImage(),
                           isOn: .constant(true),
                           alternateImage: NSImage(),
                           autoInvertImage: false,
                           isBordered: false,
                           toolTip: "this is a tooltip")
        XCTAssertNil(button.title)
        XCTAssertNil(button.attributedTitle)
        XCTAssertNotNil(button.image)
        XCTAssertNotNil(button.alternateImage)
        XCTAssertFalse(button.isBordered!)
        XCTAssertEqual(button.toolTip, "this is a tooltip")
        XCTAssertFalse(button.autoInvertImage)
    }

    func testNSCommandModifiers() {
        var button = KSSToggle("button", isOn: .constant(true))
        XCTAssertNil(button.nsControlViewSettings.font)
        XCTAssertNil(button.nsControlViewSettings.fontSize)

        button = button.nsFont(NSFont.boldSystemFont(ofSize: 10))
        XCTAssertNotNil(button.nsControlViewSettings.font)
        XCTAssertNil(button.nsControlViewSettings.fontSize)

        button = button.nsFontSize(10)
        XCTAssertNotNil(button.nsControlViewSettings.font)
        XCTAssertEqual(button.nsControlViewSettings.fontSize, 10)
    }
}
