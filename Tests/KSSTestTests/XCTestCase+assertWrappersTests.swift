
import XCTest
import KSSTest

class XCTestCaseAssertWrappersTests: XCTestCase {
    func testBoolean() throws {
        assertTrue { true }
        assertTrue {
            try fnThatThrows()
            return true
        }
        assertFalse { false }
        assertFalse {
            try fnThatThrows()
            return false
        }
    }

    func testEquality() throws {
        assertEqual(to: 10) { 2 * 5 }
        assertEqual(to: 10) {
            try fnThatThrows()
            return 2 * 5
        }
        assertNotEqual(to: 10) { 3 * 5 }
        assertNotEqual(to: 10) {
            try fnThatThrows()
            return 3 * 5
        }
    }

    func testNil() throws {
        assertNil { nil }
        assertNil {
            try fnThatThrows()
            return nil
        }
        assertNotNil { 10 }
        assertNotNil {
            try fnThatThrows()
            return 10
        }
    }

    func testThrows() throws {
        assertNoThrow { }
        assertNoThrow {
            try fnThatThrows()
        }
        assertThrows {
            throw MyError.somethingWrong
        }
        assertThrowsError(ofType: MyError.Type.self) {
            throw MyError.somethingWrong
        }
        assertThrowsError(ofValue: MyError.somethingElseWrong) {
            throw MyError.somethingElseWrong
        }
    }
}

func fnThatThrows() throws {
    // Well, not really. It just declares that it throws.
}

fileprivate enum MyError: Error {
    case somethingWrong
    case somethingElseWrong
}
