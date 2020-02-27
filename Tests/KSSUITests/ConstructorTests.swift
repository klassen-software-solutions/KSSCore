//
//  Created by Steven W. Klassen on 2020-02-27.
//

import SwiftUI
import XCTest

import KSSUI

@available(OSX 10.15.0, *)
fileprivate struct MyView: View {
    @State private var testMutableAttributedString = NSMutableAttributedString()
    @State private var url: URL? = nil
    @State private var url2 = URL(string: "http://hello.not.there/")!

    var body: some View {
        VStack {
            KSSCommandTextField(command: .constant("hi"))
            KSSCommandTextField(command: .constant("hi"), helpText: "message to send")
            KSSNativeButton("Hi") { print("hi") }
            KSSNativeButton(attributedTitle: NSAttributedString()) { print("hi") }
            KSSTextView(text: $testMutableAttributedString)
            KSSURLTextField(url: $url)
            KSSWebView(url: $url2)
        }
    }
}

class ConstructorTests: XCTestCase {
    func testObjectWillCompile() {
        // Intentionally empty. This file tests that the UI controls can be included
        // in a view. It is a compile, not a runtime, test.
    }
}
