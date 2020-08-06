//
//  KSSNativeButtonTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-05.
//

import Foundation
import SwiftUI
import XCTest

import KSSUI

@available(OSX 10.15, *)
class KSSNativeButtonTests: XCTestCase {
    struct TestThatItCompilesInAView : View {
        var body: some View {
            VStack {
                KSSNativeButton("button 1") { print("button 1") }
                KSSNativeButton("button 2",
                                keyEquivalent: .escape,
                                buttonType: .momentaryLight,
                                bezelStyle: .circular,
                                isBordered: true,
                                toolTip: "this is a tooltip") { print("button 2") }
                    .nsFont(NSFont.systemFont(ofSize: 10))
                    .nsFontSize(12)
            }
        }
    }


    func testConstruction() {
        var button = KSSNativeButton("button") { print("hi") }
        XCTAssertEqual(button.title, "button")
        XCTAssertNil(button.attributedTitle)
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertNil(button.keyEquivalent)
        XCTAssertNil(button.buttonType)
        XCTAssertNil(button.bezelStyle)
        XCTAssertNil(button.isBordered)
        XCTAssertNil(button.toolTip)
        XCTAssertTrue(button.autoInvertImage)

        button = KSSNativeButton("button",
                                 keyEquivalent: .return,
                                 buttonType: .momentaryPushIn,
                                 bezelStyle: .inline,
                                 isBordered: false,
                                 toolTip: "this is a tooltip") { print("hi") }
        XCTAssertEqual(button.title, "button")
        XCTAssertNil(button.attributedTitle)
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertEqual(button.keyEquivalent, .return)
        XCTAssertEqual(button.buttonType, .momentaryPushIn)
        XCTAssertEqual(button.bezelStyle, .inline)
        XCTAssertFalse(button.isBordered!)
        XCTAssertEqual(button.toolTip, "this is a tooltip")
        XCTAssertTrue(button.autoInvertImage)

        button = KSSNativeButton(withAttributedTitle: NSAttributedString(string: "button")) { print("hi") }
        XCTAssertNil(button.title)
        XCTAssertEqual(button.attributedTitle, NSAttributedString(string: "button"))
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertNil(button.keyEquivalent)
        XCTAssertNil(button.buttonType)
        XCTAssertNil(button.bezelStyle)
        XCTAssertNil(button.isBordered)
        XCTAssertNil(button.toolTip)
        XCTAssertTrue(button.autoInvertImage)

        button = KSSNativeButton(withAttributedTitle: NSAttributedString(string: "button"),
                                 keyEquivalent: .return,
                                 buttonType: .momentaryPushIn,
                                 bezelStyle: .inline,
                                 isBordered: false,
                                 toolTip: "this is a tooltip") { print("hi") }
        XCTAssertNil(button.title)
        XCTAssertEqual(button.attributedTitle, NSAttributedString(string: "button"))
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertEqual(button.keyEquivalent, .return)
        XCTAssertEqual(button.buttonType, .momentaryPushIn)
        XCTAssertEqual(button.bezelStyle, .inline)
        XCTAssertFalse(button.isBordered!)
        XCTAssertEqual(button.toolTip, "this is a tooltip")
        XCTAssertTrue(button.autoInvertImage)

        button = KSSNativeButton(withImage: NSImage()) { print("hi") }
        XCTAssertNil(button.title)
        XCTAssertNil(button.attributedTitle)
        XCTAssertNotNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertNil(button.keyEquivalent)
        XCTAssertNil(button.buttonType)
        XCTAssertNil(button.bezelStyle)
        XCTAssertNil(button.isBordered)
        XCTAssertNil(button.toolTip)
        XCTAssertTrue(button.autoInvertImage)

        button = KSSNativeButton(withImage: NSImage(),
                                 alternateImage: NSImage(),
                                 autoInvertImage: false,
                                 keyEquivalent: .return,
                                 buttonType: .momentaryPushIn,
                                 bezelStyle: .inline,
                                 isBordered: false,
                                 toolTip: "this is a tooltip") { print("hi") }
        XCTAssertNil(button.title)
        XCTAssertNil(button.attributedTitle)
        XCTAssertNotNil(button.image)
        XCTAssertNotNil(button.alternateImage)
        XCTAssertEqual(button.keyEquivalent, .return)
        XCTAssertEqual(button.buttonType, .momentaryPushIn)
        XCTAssertEqual(button.bezelStyle, .inline)
        XCTAssertFalse(button.isBordered!)
        XCTAssertEqual(button.toolTip, "this is a tooltip")
        XCTAssertFalse(button.autoInvertImage)
    }

    func testNSCommandModifiers() {
        var button = KSSNativeButton("button") { print("hi") }
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
