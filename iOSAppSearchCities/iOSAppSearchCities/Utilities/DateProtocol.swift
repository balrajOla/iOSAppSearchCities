//
//  DateProtocol.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 15/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
public protocol DateProtocol {
  var date: Date { get }
  func addingTimeInterval(_: TimeInterval) -> Self
  init()
  init(timeIntervalSince1970: TimeInterval)
  var timeIntervalSince1970: TimeInterval { get }
}

extension Date: DateProtocol {
  public var date: Date {
    return self
  }
}
