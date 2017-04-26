//
//  Utils.swift
//  AniLog
//
//  Created by David Fang on 4/16/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

func getTagColor(_ tag_num: Int16) -> UIColor {
    switch tag_num {
    case 0:
        return UIColor.sunsetOrange
    case 1:
        return UIColor.deepseaBlue
    case 2:
        return UIColor.regalRed
    case 3:
        return UIColor.softPurple
    case 4:
        return UIColor.forestGreen
    case 5:
        return UIColor.steelGray
    default:
        return UIColor.clear   // should never enter
    }
}
