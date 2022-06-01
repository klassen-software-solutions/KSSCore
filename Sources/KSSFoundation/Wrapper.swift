//
//  Wrapper.swift
//  
//
//  Created by Steven W. Klassen on 2021-03-25.
//

import Foundation

/**
 Simple wrapper class to be used when you need a pass-by-value object, like
 a struct, to outlive its scope.
 */
public class Wrapper<Struct> {
    public init(object: Struct? = nil) {
        self.object = object
    }

    public var object: Struct? = nil
}
