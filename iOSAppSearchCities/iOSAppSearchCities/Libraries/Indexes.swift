//
//  Indexes.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

struct Indexes {
    var value: [String: Any]
    
    init(for key: String) {
        // Load indexes from persistent
        self.value = [String: Any]()
    }
    
    func save(forKeyPath keyPath: String) -> Future<Bool> {
        return Future<Bool>.init(value: true)
    }
    
    func get(forKeyPath keyPath: String) -> Future<[String]> {
        return Future<[String]>.init(value: [String]())
    }
}
