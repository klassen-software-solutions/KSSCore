//
//  Dictionary+caseInsensitiveSubscript.swift
//  
//
//  Created by Steven W. Klassen on 2021-05-21.
//

import Foundation


public extension Dictionary where Key == String {

    /**
     Provide a case insensitive access into a dictionary. This will be case preserving in
     that it will honour the case first used when adding a key.

     - warning: This operation is O(n) instead of the O(1) which is expected of a dictionary.
     - warning: Only this operation is case insensitive, the underlying dictionary is not.
        So if you mix this with case sensitive operations you may not get the results that
        you desire.

     - note: This is based on code found at
     https://stackoverflow.com/questions/33182260/case-insensitive-dictionary-in-swift
     */
    subscript(caseInsensitive key: Key) -> Value? {
        get {
            if let k = keys.first(where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                return self[k]
            }
            return nil
        }
        set {
            if let k = keys.first(where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                self[k] = newValue
            } else {
                self[key] = newValue
            }
        }
    }
}
