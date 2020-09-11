import XCTest
import KSSTest

class XCTestCaseExpectTests: XCTestCase {
    func testExpect() throws {
        expect {
            let expectation = self.expectation(description: "one")
            expectation.expectedFulfillmentCount = 5
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }

        expect(within: 2) {
            let expectation = self.expectation(description: "one")
            expectation.expectedFulfillmentCount = 5
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }

        expect(within: 0.1) {
            let expectation = self.expectation(description: "one")
            expectation.expectedFulfillmentCount = 5
            expectation.isInverted = true
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }

        expect(within: 0.1) {
            let shouldFulfill = self.expectation(description: "should fulfill")
            let shouldNotFulfill = self.expectation(description: "should not fulfill")
            shouldNotFulfill.isInverted = true
            shouldFulfill.fulfill()
        }
    }

    @available(*, deprecated)
    func testExpectDeprecated() throws {
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

        expect(willNotFulfill: 5, within: 0.1) { expectation in
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }
    }

    @available(*, deprecated)
    func testExpectWillFulfill() throws {
        expectWillFulfill { expectation in
            expectation.fulfill()
        }

        expectWillFulfill(within: 2) { expectation in
            expectation.fulfill()
        }
    }

    @available(*, deprecated)
    func testExpectWillNotFulfill() throws {
        expectWillNotFulfill { _ in }
        expectWillNotFulfill(within: 0.1) { _ in }
    }
}
