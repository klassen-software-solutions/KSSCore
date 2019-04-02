//
//  ArrayExtensionTests.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-17.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSCore

class ArrayExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicFunctionality() {
        var ar = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
        var removedAr = ar.remove(atIndices: IndexSet([0, 2]))
        XCTAssert(removedAr == ["three", "one"])
        XCTAssert(ar == ["two", "four", "five", "six", "seven", "eight", "nine", "ten"])

        removedAr = ar.remove(atIndices: IndexSet([3, 4, 5]))
        XCTAssert(removedAr == ["eight", "seven", "six"])
        XCTAssert(ar == ["two", "four", "five", "nine", "ten"])

        removedAr = ar.remove(atIndices: IndexSet())
        XCTAssert(removedAr.isEmpty)
        XCTAssert(ar == ["two", "four", "five", "nine", "ten"])

        removedAr = ar.remove(atIndices: IndexSet([4]))
        XCTAssert(removedAr == ["ten"])
        XCTAssert(ar == ["two", "four", "five", "nine"])
    }

}
