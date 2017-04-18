//
//  PlusButtonView.swift
//  AniLog
//
//  Created by David Fang on 4/17/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

@IBDesignable
class PlusButtonView: UIButton {

    @IBInspectable var fillColor: UIColor = UIColor.black
    @IBInspectable var strokeColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        
        // Create the circle
        
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        // Create the plus
        
        let plusHeight: CGFloat = 1.5
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        let plusPath = UIBezierPath()

        plusPath.lineWidth = plusHeight
        plusPath.move(to: CGPoint(
            x:bounds.width/2 - plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        plusPath.move(to: CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 - plusWidth/2 + 0.5))
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 + plusWidth/2 + 0.5))
        
        strokeColor.setStroke()
        plusPath.stroke()
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.6 : 1.0
        }
    }
    
}
