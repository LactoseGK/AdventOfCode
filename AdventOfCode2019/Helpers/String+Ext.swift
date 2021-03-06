//
//  String+Ext.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 04/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

extension String {
    func toStringArray() -> [String] {
        return self.map({"\($0)"})
    }
    
    func loadAsTextStringArray(fileType: String? = "txt", separator: String = "\n") -> [String] {
        return FileLoader.loadText(fileName: self, fileType: fileType).components(separatedBy: separator).filter({!$0.isEmpty})
    }
    
    func loadAsTextString(fileType: String? = "txt") -> String {
        return FileLoader.loadText(fileName: self, fileType: fileType)
    }
    
    func loadJSON<T: Codable>(fileType: String? = "txt", parseType: T.Type) -> T {
        return FileLoader.loadJSON(fileName: self, fileType: fileType, parseType: parseType)
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var boolValue: Bool? {
        if self.lowercased() == "true" {
            return true
        } else if self.lowercased() == "false" {
            return false
        }
        if let intValue = self.intValue {
            return intValue != 0
        }
        return nil
    }
    
    func ranges(of searchString: String) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex != self.endIndex {
            let range = startIndex..<self.endIndex
            if let foundRange = self.range(of: searchString, range: range) {
                ranges.append(foundRange)
            } else {
                break
            }
            startIndex = self.index(after: startIndex)
        }
        
        return ranges
    }
}
