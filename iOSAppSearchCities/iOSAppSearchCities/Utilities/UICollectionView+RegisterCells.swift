//
//  UICollectionView+RegisterCells.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  public func register<T>(_ anyClass : T.Type, bundle : Bundle) -> Void where T : UICollectionViewCell {
    self.register(UINib(nibName: String.stringFromClass(anyClass), bundle: bundle), forCellWithReuseIdentifier: String.stringFromClass(anyClass))
  }
  
  public func registerCells<T>(_ cells : [T.Type], bundle : Bundle) -> Void where T : UICollectionViewCell {
    for cellClass in cells {
      self.register(cellClass, bundle : bundle)
    }
  }
}

extension UITableView {
  
  public func register<T>(_ anyClass : T.Type, bundle : Bundle) -> Void where T : UITableViewCell {
    self.register(UINib(nibName: String.stringFromClass(anyClass), bundle: bundle), forCellReuseIdentifier: String.stringFromClass(anyClass))
  }
  
  public func registerCells<T>(_ cells : [T.Type], bundle : Bundle) -> Void where T : UITableViewCell {
    for cellClass in cells {
      self.register(cellClass, bundle : bundle)
    }
  }
}

extension String {
  
  static func stringFromClass(_ anyClass : AnyClass) -> String {
    let string = NSStringFromClass(anyClass)
    return string.components(separatedBy: ".").last!
  }
  
}
