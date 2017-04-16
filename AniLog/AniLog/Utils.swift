//
//  Utils.swift
//  AniLog
//
//  Created by David Fang on 4/16/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

func trueMod(_ a: Int16, _ n: Int16) -> Int16 {
    let r = a % n
    return r >= 0 ? r : r + n
}
