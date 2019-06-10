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
    
    init(for key: String) {
        // Load indexes from persistent
        self.key = key
    }
    
    func save(forKeyPath keyPath: KeyPath, value: String) -> Future<Bool> {
        var valueToUpdate = (AppEnvironment.current.cache[self.key] as? [String : Any]) ?? [String : Any]()
        valueToUpdate[keyPath: keyPath] = value
        AppEnvironment.current.cache[self.key] = valueToUpdate
        
        return Future<Bool>(value: true)
    }
    
    func get(forKeyPath keyPath: KeyPath) -> Future<[String]> {
        let value = (AppEnvironment.current.cache[self.key] as? [String : Any]) ?? [String : Any]()
        let valueForKeyPath = value[keyPath: keyPath]
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
