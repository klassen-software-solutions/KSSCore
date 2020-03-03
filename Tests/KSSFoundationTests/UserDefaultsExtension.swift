//
//  UserDefaultsExtension.swift
//
//  Created by Steven W. Klassen on 2020-02-29.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation
import XCTest
import KSSFoundation

class UserDefaultsExtension: XCTestCase {

    func testThatSettingInitialValuePutsItThere() {
        let userDefaults = UserDefaults.standard
        userDefaults.setInitialValue(10, forKey: "MyIntegerTest")
        userDefaults.setInitialValue("hi", forKey: "MyStringTest")
        XCTAssertEqual(userDefaults.integer(forKey: "MyIntegerTest"), 10)
        XCTAssertEqual(userDefaults.string(forKey: "MyStringTest"), "hi")
    }

    func testThatSettingInitialValuesHasNoEffectOnExistingOnes() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(1, forKey: "MyExistingIntegerTest")
        userDefaults.set("hello", forKey: "MyExistingStringTest")
        userDefaults.setInitialValue(10, forKey: "MyExistingIntegerTest")
        userDefaults.setInitialValue("hi", forKey: "MyExistingStringTest")
        XCTAssertEqual(userDefaults.integer(forKey: "MyExistingIntegerTest"), 1)
        XCTAssertEqual(userDefaults.string(forKey: "MyExistingStringTest"), "hello")
    }
}
