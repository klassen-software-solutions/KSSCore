
import XCTest
import KSSTest

class XCTestCaseAssertWrappersTests: XCTestCase {
    func testBoolean() throws {
        assertTrue { true }
        assertFalse { false }
    }

    func testEquality() throws {
        assertEqual(to: 10) { 2 * 5 }
        assertNotEqual(to: 10) { 3 * 5 }
    }

    func testNil() throws {
        assertNil { nil }
        assertNotNil { 10 }
    }

    func testThrows() throws {
        assertNoThrow { }
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

fileprivate enum MyError: Error {
    case somethingWrong
    case somethingElseWrong
}
