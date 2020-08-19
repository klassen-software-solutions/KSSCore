//
//  ArrayExtension.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-17.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import Foundation


public extension Array {

    /**
     Count the number of items in the array that match the given lambda.

     - returns: The number of matching elements.
     - parameters:
        - body: A lambda that takes an element and returns true if the element matches.
     */
    func countMatches(_ body: (Element) -> Bool) -> Int {
        guard !isEmpty else { return 0 }

        var totalMatches = 0
        forEach { el in
            if body(el) {
                totalMatches += 1
            }
        }
        return totalMatches
    }

    
    /**
     Remove all the items specified by the index set. Note that all the indices in the
     index set must be valid for the array.

     - returns:
        A (possibly empty) array of the elements that were removed. Note that at present
        this array will be populated in the order they elements were removed, which will be
        starting at the end of the array and moving towards the beginning.

     - parameters:
        - indices: The set of indices of the items to remove.

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


    /**
     Inserts an item into the correct position, assuming that the array is already sorted.

     - warning: The assumption that the array is already sorted is not checked. If it is not sorted
        correctly, this will not insert the element into the correct location.

     - parameters:
        - newElement: The element to be inserted.
        - by: A lambda that defines the sorting order. Specifically it should return true
            if the first element is considered less than the second.

     - returns:
        The index where the new item has been inserted.
     */
    mutating func insertInSorted(_ newElement: Element, by areInIncreasingOrder: (Element, Element) -> Bool) -> Int {
        let index = insertionIndexOf(newElement, isOrderedBefore: areInIncreasingOrder)
        insert(newElement, at: index)
        return index
    }

    // From an answer posted to
    // https://stackoverflow.com/questions/26678362/how-do-i-insert-an-element-at-the-correct-position-into-a-sorted-array-in-swift
    private func insertionIndexOf(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}


public extension Array where Element : Comparable {

    /**
     Inserts an item into the correct position, assuming that the array is already sorted. This is equivalent
     to calling `insertInSorted(:by:)` with an argument of `{ $0 < $1 }`.

     - warning: The assumption that the array is already sorted is not checked. If it is not sorted
        correctly, this will not insert the element into the correct location.

     - returns:
        The index where the new item has been inserted.
     */
    mutating func insertInSorted(_ newElement: Element) -> Int {
        return insertInSorted(newElement) { $0 < $1 }
    }

}


public extension Array where Element : Equatable {

    /**
     Returns true if all the items in the array are equal.

     - note: Also returns true if the array is empty.
     */
    var allAreEqual: Bool {
        if let firstElem = first {
            return !contains { $0 != firstElem }
        }
        return true
    }
}
