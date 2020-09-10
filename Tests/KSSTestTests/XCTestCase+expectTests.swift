import XCTest
import KSSTest

class XCTestCaseExpectTests: XCTestCase {
    func testExpect() throws {
        expect(willFulfill: 5, within: 2) { expectation in
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }

        expect(willFulfill: 5) { expectation in
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }

        expect(willNotFulfill: 5) { expectation in
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }

        expect(willNotFulfill: 5, within: 2) { expectation in
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }
    }

    func testExpectWillFulfill() throws {
        expectWillFulfill { expectation in
            expectation.fulfill()
        }

        expectWillFulfill(within: 2) { expectation in
            expectation.fulfill()
        }
    }

    func testExpectWillNotFulfill() throws {
        expectWillNotFulfill { _ in }
        expectWillNotFulfill(within: 1) { _ in }
    }
}
