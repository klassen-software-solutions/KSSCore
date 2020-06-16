//
//  NSTextCheckingResultExtension.swift
//
//  Created by Steven W. Klassen on 2020-06-16.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

import Foundation


public extension NSTextCheckingResult {

    /**
     This is a convenience method for examining the captured portions of a regular expression match.
     After you have used a regular expression search to obtain some results, you can use this
     method to return the appropriate substring. If there is no capture for a given index, then nil
     is returned.

     - note: If the return is not nil, it will be a substring of `str`.
     */
    func capture(at index: Int, in str: String) -> Substring? {
        if index < numberOfRanges {
            if let range = Range(self.range(at: index), in: str) {
                return str[range]
            }
        }
        return nil
    }
}
