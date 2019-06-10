//
//  PulseAnimation.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import UIKit

class PulseAnimationView: UIView {
  
  static var DEFAULT_COLOR = UIColor.blue
  static var DEFAULT_PADDING: CGFloat = 0
  
  @IBInspectable var color: UIColor = PulseAnimationView.DEFAULT_COLOR
  @IBInspectable var padding: CGFloat = PulseAnimationView.DEFAULT_PADDING
  
  var totalEdgeHeight: CGFloat = 24
  
  private func getCircleLayer(size: CGSize, color: UIColor) -> CALayer {
    let layer: CAShapeLayer = CAShapeLayer()
    let path: UIBezierPath = UIBezierPath()
    path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                radius: size.width / 2,
                startAngle: 0,
                endAngle: CGFloat(2 * Double.pi),
                clockwise: false)
    layer.fillColor = color.cgColor
    layer.backgroundColor = nil
    layer.path = path.cgPath
    layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    return layer
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    isHidden = true
  }
  
  /**
   Start animating.
   */
  final func startAnimating() {
    isHidden = false
    setUpAnimation()
  }
  
  /**
   Stop animating.
   */
  final func stopAnimating() {
    isHidden = true
    layer.sublayers?.removeAll()
  }
  
  func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
    let circleSpacing: CGFloat = 2
    let circleSize: CGFloat = (size.width - 2 * circleSpacing) / 3
    let x: CGFloat = (layer.bounds.size.width - size.width) / 2
    let y: CGFloat = (layer.bounds.size.height - circleSize) / 2
    let duration: CFTimeInterval = 1.3
    let beginTime = CACurrentMediaTime()
    let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
    let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
    let animation = CAKeyframeAnimation(keyPath: "transform.scale")
    
    // Animation
    animation.keyTimes = [0, 0.3, 1]
    animation.timingFunctions = [timingFunction, timingFunction]
    animation.values = [1, 0.3, 1]
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false
    
    // Draw circles
    for i in 0 ..< 3 {
      let circle = getCircleLayer(size: CGSize(width: circleSize, height: circleSize), color: color)
      let frame = CGRect(x: x + circleSize * CGFloat(i) + circleSpacing * CGFloat(i),
                         y: y,
                         width: circleSize,
                         height: circleSize)
      
      animation.beginTime = beginTime + beginTimes[i]
      circle.frame = frame
      circle.add(animation, forKey: "animation")
      layer.addSublayer(circle)
    }
  }
  
  private final func setUpAnimation() {
    var animationRect = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    layer.sublayers = nil
    animationRect.size = CGSize(width: totalEdgeHeight, height: totalEdgeHeight)
    setUpAnimation(in: layer, size: animationRect.size, color: color)
  }
}

