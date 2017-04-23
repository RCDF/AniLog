//
//  Testing.swift
//  AniLog
//
//  Created by David Fang on 4/22/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import Foundation

let randomEnabled = false

func createWeekTestLogs() {
    if (randomEnabled) {
        let weekStrings = getWeekDateStrings()
        for dateString in weekStrings {
            let log = getLogFromString(dateString: dateString)
            log?.totalHours = getRandomHours()
        }
    } else {
        let l1 = getLogFromString(dateString: "04222017")
        l1?.totalHours = 18.35
        
        let l2 = getLogFromString(dateString: "04212017")
        l2?.totalHours = 18.47
        
        let l3 = getLogFromString(dateString: "04202017")
        l3?.totalHours = 0.03

        let l4 = getLogFromString(dateString: "04192017")
        l4?.totalHours = 3.2
        
        let l5 = getLogFromString(dateString: "04182017")
        l5?.totalHours = 3.7
        
        let l6 = getLogFromString(dateString: "04172017")
        l6?.totalHours = 7.2
        
        let l7 = getLogFromString(dateString: "04162017")
        l7?.totalHours = 5.41
    }
}

func createMonthTestLogs() {
    let monthStrings = getMonthDateStrings()
    for dateString in monthStrings {
        let log = getLogFromString(dateString: dateString)
        log?.totalHours = getRandomHours()
    }
}

func getRandomHours() -> Double {
    return Double(arc4random_uniform(24) + 1)
}
