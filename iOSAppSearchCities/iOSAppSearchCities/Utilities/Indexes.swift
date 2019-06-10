//
//  Indexes.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

struct Indexes {
    let key: String
    var value: [String: Any]
    
    init(for key: String) {
        // Load indexes from persistent
        self.key = key
        self.value = (AppEnvironment.current.cache[self.key] as? [String : Any]) ?? [String: Any]()
    }
    
    mutating func save(forKeyPath keyPath: KeyPath, value: String) -> Future<Bool> {
        self.value[keyPath: keyPath] = value
        AppEnvironment.current.cache[self.key] = self.value
        return Future<Bool>(value: true)
    }
    
    mutating func get(forKeyPath keyPath: KeyPath) -> Future<[String]> {
        self.value = (AppEnvironment.current.cache[self.key] as? [String : Any]) ?? self.value
        let valueForKeyPath = self.value[keyPath: keyPath]
        let defaultValue = Future<[String]>.pure([String]())
        
        switch valueForKeyPath {
        case let values as [String]?:
            return values.map { Future<[String]>.pure($0) } ?? defaultValue
        case let singleValue as String?:
            return singleValue.map{ Future<[String]>.pure([$0]) } ?? defaultValue
        default:
            return defaultValue
        }
    }
}
