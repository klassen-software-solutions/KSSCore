//
//  cast.swift
//
//  Created by Steven W. Klassen on 2020-03-02.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation


/**
 Performs an `as?` cast to the type `T` but throws an error instead of returning `nil` if the cast fails.
 This can be useful if you are already in a `do` block and would rather handle the failure to cast in
 your `catch` blocks.
 */
public func castAs<T>(_ a: Any) throws -> T {
    if let t = a as? T {
        return t
    }
    throw CastError.castFailed
}

public enum CastError: Error {
    /**
     The error that is thrown by `castAs` if the cast fails.
     */
    case castFailed
}
