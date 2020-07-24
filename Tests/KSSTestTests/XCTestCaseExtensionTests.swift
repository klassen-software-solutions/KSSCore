import XCTest
import KSSTest

class XCTestCaseExtensionTests: XCTestCase {
    func testExpect() throws {
        expect(willFulfill: 5, within: 1) { expectation in
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }

        expect(willNotFulfill: 5, within: 1) { expectation in
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }
    }

    func testExpectWillFulfill() throws {
        expectWillFulfill(within: 1) { expectation in
            expectation.fulfill()
        }
    }

    func testExpectWillNotFulfill() throws {
        expectWillNotFulfill(within: 1) { _ in }
    }
}
