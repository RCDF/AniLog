//
//  FadingScrollView.swift
//  AniLog
//
//  Created by David Fang on 4/17/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import QuartzCore

class FadingTableView: UITableView {
    
    let transparentColor = UIColor.white.withAlphaComponent(0).cgColor
    let opaqueColor = UIColor.white.withAlphaComponent(1).cgColor
    let fadePercentage: Double = 0.3

    private var maskLayer: CALayer!
    private var gradientLayer: CAGradientLayer!
    var maskIsHidden: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if (maskLayer == nil) {
            maskLayer = CALayer()
            maskLayer.frame = self.bounds
            
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            gradientLayer.colors = [opaqueColor, transparentColor]
            gradientLayer.locations = [NSNumber(value: 1.0 - fadePercentage), 1.0]
            
            maskLayer.addSublayer(gradientLayer)
            self.layer.mask = maskLayer
        }
        
        updateMask()
    }
    
    func updateMask() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.frame = self.bounds
        CATransaction.commit()
        
        updateGradients()
    }
    
    func updateGradients() {
        let contentOffset: Float = Float(self.contentOffset.y)
        let maxContentOffset: Float = roundf(Float(self.contentSize.height - self.bounds.height))
        
        if (!self.maskIsHidden && contentOffset >= maxContentOffset) {
            print("Hiding")
            hideMask()
        } else if (self.maskIsHidden && contentOffset < maxContentOffset) {
            print("Showing")
            showMask()
        }
    }
    
    func hideMask() {
        maskIsHidden = true
        
        let animation = CABasicAnimation.init(keyPath: "color")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [opaqueColor, opaqueColor]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.colors = [opaqueColor, opaqueColor]
        CATransaction.commit()

        gradientLayer.add(animation, forKey: "animateGradient")
    }
    
    func showMask() {
        maskIsHidden = false
        
//        let animation = CABasicAnimation.init(keyPath: "color")
//        animation.fromValue = gradientLayer.colors
//        animation.toValue = [opaqueColor, transparentColor]
//        animation.duration = CFTimeInterval(0.3)
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.colors = [opaqueColor, transparentColor]
        CATransaction.commit()
        
//        gradientLayer.add(animation, forKey: "animateGradient")
    }
}
