//
//  Created by Steven W. Klassen on 2020-02-27.
//

import SwiftUI
import XCTest

import KSSUI

@available(OSX 10.15.0, *)
fileprivate struct MyView: View {
    @State private var url: URL? = nil
    @State private var url2 = URL(string: "http://hello.not.there/")!
    @State private var testBool: Bool = true

    var body: some View {
        VStack {
            Group {
                KSSCommandTextField(command: .constant("hi"))
                KSSCommandTextField(command: .constant("hi"), helpText: "message to send")
            }
            Group {
                KSSNativeButton("Hi") { print("hi") }
                KSSNativeButton(withAttributedTitle: NSAttributedString()) { print("hi") }
                KSSNativeButton(withImage: NSImage()) { print("hi") }
                KSSToggle("Hi", isOn: $testBool)
                KSSToggle(withAttributedTitle: NSAttributedString(), isOn: $testBool)
                KSSToggle(withImage: NSImage(), isOn: $testBool)
            }
            Group {
                KSSURLTextField(url: $url)
                KSSSearchField()
            }
        }
    }
}

class ConstructorTests: XCTestCase {
    func testObjectWillCompile() {
        // Intentionally empty. This file tests that the UI controls can be included
        // in a view. It is a compile, not a runtime, test.
    }

    func testKSSSearchField() {
        var sf = KSSSearchField()
        XCTAssertEqual(sf.helpText, "")
        XCTAssertEqual(sf.recentSearchesKey, "")
        XCTAssertNil(sf.searchCallback)

        sf = KSSSearchField(helpText: "hello", recentSearchesKey: "world") { text in }
        XCTAssertEqual(sf.helpText, "hello")
        XCTAssertEqual(sf.recentSearchesKey, "world")
        XCTAssertNotNil(sf.searchCallback)
    }
}
