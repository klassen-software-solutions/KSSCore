//
//  XCTestCase+expect.swift
//
//  Created by Steven W. Klassen on 2020-07-22.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

import XCTest

// MARK: Expectation Methods

/**
 Expectation Methods

 This extension adds methods making it simpler to work with simple expectations. Essentially they allow
 you to place your code in a lambda, and call the necessary `fulfill` method on the `expectation`
 that is passed to your lambda. This allows you to use the expectations without having to manually
 create and remove them.
 */
public extension XCTestCase {
    /**
     Assert that an expectation will be fulfilled a specific number of times within a given time interval.
     - note: The lambda you provide should call the expectation `fulfill` method.
     */
    func expect(willFulfill fulfillmentCount: Int,
                within timeout: TimeInterval = 1.0,
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
    func expectWillFulfill(within timeout: TimeInterval = 1.0,
                           _ lambda: (XCTestExpectation) -> Void)
    {
        expect(willFulfill: 1, within: timeout, lambda)
    }

    /**
     Assert that an expectation will not be fulfilled a specific number of times within a given time interval.
     */
    func expect(willNotFulfill fulfillmentCount: Int,
                within timeout: TimeInterval = 1.0,
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
    func expectWillNotFulfill(within timeout: TimeInterval = 1.0,
                              _ lambda: (XCTestExpectation) -> Void)
    {
        expect(willNotFulfill: 1, within: timeout, lambda)
    }
}

