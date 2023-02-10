//
//  Loader.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit

class Loader: NSObject {
  
  private static var pulseView: PulseAnimationView?
  
  @objc static func show(blockingLoader: Bool = false) {
    guard let window = UIApplication.shared.keyWindow else {
      return
    }
    self.hide()
    let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    self.pulseView = PulseAnimationView(frame: frame)
    self.pulseView?.center = CGPoint(x: window.center.x , y: (window.bounds.height * 0.8))
    self.pulseView.map { window.addSubview($0) }
    self.pulseView?.startAnimating()
    self.pulseView.map { window.bringSubviewToFront($0) }
    window.isUserInteractionEnabled = !blockingLoader
  }
  
  @objc static func hide() {
    self.pulseView?.stopAnimating()
    self.pulseView?.removeFromSuperview()
    UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
  }
  
  @objc static func show(onView view: UIView) {
    self.hide(onView: view)
    let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    self.pulseView = PulseAnimationView(frame: frame)
    self.pulseView?.center = view.center
    self.pulseView.map { view.addSubview($0) }
    self.pulseView?.startAnimating()
    self.pulseView.map { view.bringSubviewToFront($0) }
    view.isUserInteractionEnabled = false
  }
  
  @objc static func hide(onView view: UIView) {
    self.pulseView?.stopAnimating()
    self.pulseView?.removeFromSuperview()
    view.isUserInteractionEnabled = true
  }
}

