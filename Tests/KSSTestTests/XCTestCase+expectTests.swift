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
}
