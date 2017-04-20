//
//  RoundButton.swift
//  AniLog
//
//  Created by David Fang on 4/20/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 1.5
    @IBInspectable var borderColor: UIColor = UIColor.black

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
