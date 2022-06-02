//
//  String+range.swift
//  
//
//  Created by Steven W. Klassen on 2022-06-02.
//

import Foundation


public extension String {

    /**
     The full range of the string.
     */
    var range: NSRange { NSRange(self.startIndex..., in: self) }
}
