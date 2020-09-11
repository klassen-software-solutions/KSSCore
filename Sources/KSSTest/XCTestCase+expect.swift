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
}
