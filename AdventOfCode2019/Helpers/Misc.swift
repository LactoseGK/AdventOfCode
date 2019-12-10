//
//  Misc.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 08/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

typealias IntBlock = ((Int) -> Void)

// Source: https://stackoverflow.com/a/55395494
extension RandomAccessCollection where Element : Comparable {
    func insertionIndex(of value: Element) -> Index {
        var slice: SubSequence = self[...]
        
        while !slice.isEmpty {
            let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
            if value < slice[middle] {
                slice = slice[..<middle]
            } else {
                slice = slice[index(after: middle)...]
            }
        }
        return slice.startIndex
    }
    
    func insertionIndex(for predicate: (Element) -> Bool) -> Index {
        var slice: SubSequence = self[...]
        
        while !slice.isEmpty {
            let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
            if predicate(slice[middle]) {
                slice = slice[index(after: middle)...]
            } else {
                slice = slice[..<middle]
            }
        }
        return slice.startIndex
    }
}
