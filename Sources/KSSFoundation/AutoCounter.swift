//
//  AutoCounter.swift
//  
//
//  Created by Steven W. Klassen on 2020-02-26.
//

import Foundation

/**
 Class for generating a counter that starts at 1 and increments each time next() is called.
 */
public class AutoCounter {
    private var nextValue = 1

    /**
     Constructs a counter whose never value will be 1.
     */
    public init() {}

    /**
     Returns the next integer from the counter.
     */
    public func next() -> Int {
        let ret = nextValue
        nextValue += 1
        return ret
    }
}
