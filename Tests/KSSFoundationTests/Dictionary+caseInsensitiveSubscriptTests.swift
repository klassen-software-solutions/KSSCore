//
//  Dictionary+caseInsensitiveSubscriptTests.swift
//  
//
//  Created by Steven W. Klassen on 2021-05-21.
//

import Foundation
import XCTest

import KSSTest

@testable import KSSFoundation


class DictionaryCaseInsensitiveSubscriptTests: XCTestCase {
    func testSubscriptAccess() throws {
        var d = ["one": 1]
        assertEqual(to: 1) { d.count }
        assertEqual(to: 1) { d["one"] }
        assertNil { d["ONE"] }
        assertNil { d["oNe"] }
        assertEqual(to: 1) { d[caseInsensitive: "one"] }
        assertEqual(to: 1) { d[caseInsensitive: "ONE"] }
        assertEqual(to: 1) { d[caseInsensitive: "oNe"] }

        d[caseInsensitive: "TWO"] = 2
        assertEqual(to: 2) { d.count }
        d[caseInsensitive: "two"] = -2
        assertEqual(to: -2) { d["TWO"] }
        assertEqual(to: -2) { d[caseInsensitive: "TWO"] }
    }
}
