//
//  UserDefaultsExtension.swift
//
//  Created by Steven W. Klassen on 2020-02-29.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Foundation

public extension UserDefaults {

    /**
     Sets a value for the key, but only if it has never been set. This is useful if you need to ensure an
     initial value that differs from the OSes default.

     - note: This will call `set(:forKey:)` hence will work for any type `T` for which that
        call is valid.

     - parameters:
        - value: The value to be set.
        - forKey: The key to use.
     */
    func setInitialValue<T>(_ value: T, forKey defaultName: String) {
        if object(forKey: defaultName) == nil {
            set(value, forKey: defaultName)
        }
    }
}
