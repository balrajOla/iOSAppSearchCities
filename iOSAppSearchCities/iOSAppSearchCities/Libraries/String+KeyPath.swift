//
//  String+KeyPath.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 10/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

extension String {
    func keyPath(withDepthIndex index: Int = 2) -> KeyPath {
        guard !self.isEmpty else {
            return ""
        }
        
        return KeyPath(self.replacingOccurrences(of: " ", with: "_").permute(withMaxLength: index).joined(separator: "."))
    }
    
    func permute(withMaxLength length: Int = 2) -> [String] {
        guard !self.isEmpty else {
            return [String]()
        }
        
        let maxLength = (self.count > length) ? length : self.count
        
        return self.reduce([String]()) {(result: [String], character: Character) -> [String] in
            guard (result.last?.count ?? 0) < maxLength else {
                    return result
            }
            
            let lastValue = result.last
            if let finalResult  = (lastValue.map { value -> [String] in
                var lastString = value
                lastString.append(character)
                
                var newResult = result
                newResult.append(lastString)
                return newResult
            }) {
                return finalResult
            } else {
                var newResult = result
                newResult.append(String(character))
                return newResult
            }
        }
    }
}
