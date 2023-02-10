//
//  FACache.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation

public enum FACacheError: Error {
  case noValueFound
}

public final class FACache {
  private let cache = UserDefaults(suiteName: "iOSAppCache")
  
  public static let citiesIndexesKey = "citiesIndexesKey"
  public static let isIndexingCompleted = "isIndexingCompleted"
  
  public init() {
  }
  
  public subscript(key: String) -> Any? {
    get {
      return self.cache?.object(forKey: key)
    }
    set {
      if let newValue = newValue {
        self.cache?.set(newValue, forKey: key)
      } else {
        self.cache?.removeObject(forKey: key)
      }
    }
  }
  
  public func removeAllObjects() {
    self.cache?.removeSuite(named: "iOSAppCache")
  }
}
