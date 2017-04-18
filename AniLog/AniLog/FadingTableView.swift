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
    
    let fadePercentage: Double = 0.3
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let transparent = UIColor.white.withAlphaComponent(0).cgColor
        let opaque = UIColor.white.withAlphaComponent(1).cgColor
        
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gradientLayer.colors = [opaque, transparent]
        gradientLayer.locations = [NSNumber(value: 1.0 - fadePercentage), 1.0]
        
        maskLayer.addSublayer(gradientLayer)
        self.layer.mask = maskLayer
    }

}
