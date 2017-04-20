//
//  TaskTagView.swift
//  AniLog
//
//  Created by David Fang on 4/18/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

class TaskTagView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
        
        self.layer.borderWidth = 1
        self.layer.borderColor = self.backgroundColor?.cgColor
    }
}
