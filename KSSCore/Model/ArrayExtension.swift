//
//  ArrayExtension.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-17.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import Foundation


public extension Array {

    /*!
     Remove all the items specified by the index set. Note that all the indices in the
     index set must be valid for the array.
     
     @return A (possibly empty) array of the elements that were removed. Note that at present
        this array will be populated in the order they elements were removed, which will be
        starting at the end of the array and moving towards the beginning.
     */
    mutating func remove(atIndices indices: IndexSet) -> [Element] {
        var removedElements = [Element]()
        if !indices.isEmpty {
            let indexArray = indices.sorted { $0 > $1 }
            for idx in indexArray {
                removedElements.append(remove(at: idx))
            }
        }
        return removedElements
    }
}
