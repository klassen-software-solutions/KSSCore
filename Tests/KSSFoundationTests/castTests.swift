//
//  castTests.swift
//
//  Created by Steven W. Klassen on 2020-03-02.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSFoundation

class castTests: XCTestCase {

    func testCastTo() {
        let a = A()
        let b = B()
        let aa = AA()
        let aac = AAComp()

        XCTAssertNoThrow(try { let _: A = try castAs(a) }())
        XCTAssertNoThrow(try { let _: A = try castAs(aa) }())
        XCTAssertNoThrow(try { let _: A = try castAs(aac) }())
        XCTAssertNoThrow(try { let _: MyProtocol = try castAs(aac) }())

        XCTAssertThrowsError(try { let _: A = try castAs(b) }()) { error in
            XCTAssertEqual(error as? CastError, CastError.castFailed)
        }
    }
}

fileprivate class A {}
fileprivate class B {}
fileprivate class AA: A {}

fileprivate protocol MyProtocol {
    func fn()
}

fileprivate class AAComp: A, MyProtocol {
    func fn() {}
}
