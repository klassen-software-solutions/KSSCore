//
//  ArrayExtensionTests.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-17.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSFoundation

class ArrayExtensionTests: XCTestCase {

    func testCountMatches() {
        let ar = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        XCTAssertEqual(ar.countMatches { el in return (el % 2) == 0 }, 5)
        XCTAssertEqual(ar.countMatches { el in return (el % 3) == 0 }, 3)
        XCTAssertEqual(ar.countMatches { el in return el < 0 }, 0)
        XCTAssertEqual(Array<Int>().countMatches { _ in return true }, 0)
    }

    func testRemove() {
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

    func testInsertInSorted() {
        var ar = [Double]()

        XCTAssertEqual(ar.insertInSorted(0.5), 0)
        XCTAssertEqual(ar, [0.5])

        XCTAssertEqual(ar.insertInSorted(0.2), 0)
        XCTAssertEqual(ar, [0.2, 0.5])

        XCTAssertEqual(ar.insertInSorted(1.5), 2)
        XCTAssertEqual(ar, [0.2, 0.5, 1.5])

        XCTAssertEqual(ar.insertInSorted(1.0), 2)
        XCTAssertEqual(ar, [0.2, 0.5, 1.0, 1.5])

        let idx = ar.insertInSorted(1.0)
        XCTAssertTrue(idx == 2 || idx == 3)
        XCTAssertEqual(ar, [0.2, 0.5, 1.0, 1.0, 1.5])
    }

    func testInsertInSortedBy() {
        var ar = [String]()

        var idx = ar.insertInSorted("bbb") { $0 > $1 }
        XCTAssertEqual(idx, 0)
        XCTAssertEqual(ar, ["bbb"])

        idx = ar.insertInSorted("ccc") { $0 > $1 }
        XCTAssertEqual(idx, 0)
        XCTAssertEqual(ar, ["ccc", "bbb"])

        idx = ar.insertInSorted("aaa") { $0 > $1 }
        XCTAssertEqual(idx, 2)
        XCTAssertEqual(ar, ["ccc", "bbb", "aaa"])

        idx = ar.insertInSorted("aab") { $0 > $1 }
        XCTAssertEqual(idx, 2)
        XCTAssertEqual(ar, ["ccc", "bbb", "aab", "aaa"])

        idx = ar.insertInSorted("aab") { $0 > $1 }
        XCTAssertTrue(idx == 2 || idx == 3)
        XCTAssertEqual(ar, ["ccc", "bbb", "aab", "aab", "aaa"])
    }

}
