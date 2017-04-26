//
//  Testing.swift
//  AniLog
//
//  Created by David Fang on 4/22/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import Foundation

let inDemoMode = false

func createWeekTestLogs() {
    if (inDemoMode) {
        let weekDates = getWeekDates()
        for date in weekDates {
            let log = getLogFor(date: date)
            log?.totalHours = getRandomHours()
        }
    }
}

func createMonthTestLogs() {
    if (inDemoMode) {
        let monthDates = getMonthDates()
        for date in monthDates {
            let log = getLogFor(date: date)
            log?.totalHours = getRandomHours()
        }
    }
}

func createYearTestLogs() {
    if (inDemoMode) {
        let yearDates = getYearDates()
        for date in yearDates {
            let log = getLogFor(date: date)
            log?.totalHours = getRandomHours()
        }
    }
}

func getRandomHours() -> Double {
    return Double(arc4random_uniform(24)) + (Double(arc4random()) / Double(UINT32_MAX))
}
