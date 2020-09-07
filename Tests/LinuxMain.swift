import XCTest

import KSSFoundationTests
import KSSTestTests

var tests = [XCTestCaseEntry]()
tests += KSSFoundationTests.__allTests()
tests += KSSTestTests.__allTests()

XCTMain(tests)
