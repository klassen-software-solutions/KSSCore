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

 This extension adds a method making it simpler to work with expectations by automating the
 `waitForExpectations` call.
 */
public extension XCTestCase {
    /**
     Assert that all expectations created within the lambda will be fulfilled within the given
     timeout. This is a convenience method that allows you to place all your expectations
     and related code in a block and have `waitForExpectations` called for you
     automatically.
     */
    func expect(within timeout: TimeInterval = 1.0, _ lambda: () -> Void) {
        lambda()
        waitForExpectations(timeout: timeout, handler: nil)
    }

    /**
     Creates a single unnamed expectation and calls `expect(within:...`.
     - note: The lambda you provide should call the expectation `fulfill` method.
     */
    @available(*, deprecated, message: "Use expect(within:_) instead")
    func expect(willFulfill fulfillmentCount: Int,
                within timeout: TimeInterval = 1.0,
                _ lambda: (XCTestExpectation) -> Void)
    {
        expect(within: timeout) {
            let expectation = self.expectation(description: "unnamed")
            expectation.expectedFulfillmentCount = fulfillmentCount
            lambda(expectation)
        }
    }

    /**
     Creates a single unnamed expectation and calls `expect(within:...`.
     - note: The lambda you provide should call the expectation `fulfill` method.
     */
    @available(*, deprecated, message: "Use expect(within:_) instead")
    func expectWillFulfill(within timeout: TimeInterval = 1.0,
                           _ lambda: (XCTestExpectation) -> Void)
    {
        expect(willFulfill: 1, within: timeout, lambda)
    }

    /**
     Creates a single unnamed expectation, inverts it, and calls `expect(within:...`.
     */
    @available(*, deprecated, message: "Use expect(within:_) instead")
    func expect(willNotFulfill fulfillmentCount: Int,
                within timeout: TimeInterval = 1.0,
                _ lambda: (XCTestExpectation) -> Void)
    {
        expect(within: timeout) {
            let expectation = self.expectation(description: "unnamed")
            expectation.expectedFulfillmentCount = fulfillmentCount
            expectation.isInverted = true
            lambda(expectation)
        }
    }

    /**
     Assert that an expectation will not be fulfilled within a given time interval.
     */
    @available(*, deprecated, message: "Use expect(within:_) instead")
    func expectWillNotFulfill(within timeout: TimeInterval = 1.0,
                              _ lambda: (XCTestExpectation) -> Void)
    {
        expect(willNotFulfill: 1, within: timeout, lambda)
    }
}

