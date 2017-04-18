//
//  FadingScrollView.swift
//  AniLog
//
//  Created by David Fang on 4/17/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import QuartzCore

/**
    A subclass of a UITableView with a dynamic gradient property
    that creates a "fading" effect at the bottom of the table view.
    The effect is dynmically hidden when the table view reaches
    the bottom in order to fully display the remaining cells.
 
    The ViewController containing the FadingTableView must also
    be a UIScrollViewDelegate and implement the scrollViewDidScroll
    function in order to dynmically update the gradients:
 
    ```swift
       func scrollViewDidScroll (...) {
           fadingTableView.updateGradients()
       }
 */
class FadingTableView: UITableView {
    
    let transparentColor = UIColor.clear.cgColor
    let opaqueColor = UIColor.black.cgColor
    let fadePercentage: Double = 0.3

    private var maskLayer: CALayer!
    private var gradientLayer: CAGradientLayer!
    private var maskIsHidden: Bool = false
    
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
    
    /**
        Update the mask's frame and redraws the gradient on that frame
     */
    private func updateMask() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.frame = self.bounds
        CATransaction.commit()
        
        updateGradients()
    }
    
    /**
        Redraw the gradient to show the specified colors. Note that
        the keyPath field should be the string of the attribute
        that your CALayer will be modifying.

        - Parameter colors: An array of CGColors to redraw onto the gradient
                      layer
     */
    private func toggleMask(_ colors: [Any]?) {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = colors
        animation.duration = CFTimeInterval(0.4)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.colors = colors
        CATransaction.commit()
        
        gradientLayer.add(animation, forKey: "gradientToggle")
    }
    
    
    // MARK: - Public Functions
    
    /**
        Update the gradient colors on the table view. When the table
        view has reached the bottom, if the mask is not already hidden,
        hide the mask by resetting the gradient colors to show opaque
        colors. Similarly, if the table view is no longer at the bottom
        and the mask is not yet shown, show the mask by resetting the
        gradient colors to show transparent colors.
     */
    func updateGradients() {
        let contentOffset: Float = Float(self.contentOffset.y)
        let maxContentOffset: Float = roundf(Float(self.contentSize.height - self.bounds.height))
        
        if (!self.maskIsHidden && contentOffset >= maxContentOffset) {
            hideMask()
        } else if (self.maskIsHidden && contentOffset < maxContentOffset) {
            showMask()
        }
    }
    
    /**
        Hide the gradient layer from the table view
     */
    func hideMask() {
        maskIsHidden = true
        let colors = [opaqueColor, opaqueColor]
        toggleMask(colors)
    }
    
    /**
        Show the gradient layer on the table view
     */
    func showMask() {
        maskIsHidden = false
        let colors = [opaqueColor, transparentColor]
        toggleMask(colors)
    }
}
