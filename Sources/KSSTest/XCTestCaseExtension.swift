//
//  XCTestCaseExtension.swift
//
//  Created by Steven W. Klassen on 2020-07-22.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

import XCTest

public extension XCTestCase {
    /**
     Assert that an expectation will be fulfilled a specific number of times within a given time interval.
     - note: The lambda you provide should call the expectation `fulfill` method.
     */
    func expect(willFulfill fulfillmentCount: Int,
                within timeout: TimeInterval,
                _ lambda: (XCTestExpectation) -> Void)
    {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = fulfillmentCount
        lambda(expectation)
        wait(for: [expectation], timeout: timeout)
    }

    /**
     Assert that an expectation will be fulfilled within a given time interval.
     - note: The lambda you provide should call the expectation `fulfill` method.
     */
    func expectWillFulfill(within timeout: TimeInterval, _ lambda: (XCTestExpectation) -> Void) {
        expect(willFulfill: 1, within: timeout, lambda)
    }

    /**
     Assert that an expectation will not be fulfilled a specific number of times within a given time interval.
     */
    func expect(willNotFulfill fulfillmentCount: Int,
                within timeout: TimeInterval,
                _ lambda: (XCTestExpectation) -> Void)
    {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = fulfillmentCount
        expectation.isInverted = true
        lambda(expectation)
        wait(for: [expectation], timeout: timeout)
    }

    /**
     Assert that an expectation will not be fulfilled within a given time interval.
     */
    func expectWillNotFulfill(within timeout: TimeInterval, _ lambda: (XCTestExpectation) -> Void) {
        expect(willNotFulfill: 1, within: timeout, lambda)
    }
}

