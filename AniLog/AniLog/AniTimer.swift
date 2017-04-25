//
//  AniTimer.swift
//  AniLog
//
//  Created by David Fang on 4/16/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import Foundation

class AniTimer {
    
    private var timerDuration: Int16
    private var hoursRemaining: Int16
    private var minutesRemaining: Int16
    private var secondsRemaining: Int16
    
    init(duration: Int16) {
        self.timerDuration = duration
        self.hoursRemaining = duration / 60
        self.minutesRemaining = duration - (60 * hoursRemaining)
        self.secondsRemaining = 0
    }
    
    func updateRemainingTime() {
        if (!isComplete()) {
            if (secondsRemaining == 0) {
                secondsRemaining = 59
                if (minutesRemaining == 0 && hoursRemaining != 0) {
                    hoursRemaining -= 1
                    minutesRemaining = 59
                } else {
                    minutesRemaining -= 1
                }
                
            } else {
                secondsRemaining -= 1
            }
        }
    }
    
    func fastForward(pauseTime: Date, resTime: Date) {
        let passedComponents = Calendar.current.dateComponents([.second, .minute, .hour], from: pauseTime, to: resTime)
        
        let hoursPassed = Int16(passedComponents.hour!)
        let minutesPassed = Int16(passedComponents.minute!)
        let secondsPassed = Int16(passedComponents.second!)

        let secondDiff = secondsRemaining - secondsPassed
        if (secondDiff < 0) {
            secondsRemaining = secondDiff + secondsPerMinute
            minutesRemaining -= 1
        } else {
            secondsRemaining = secondDiff
        }
        
        let minuteDiff = minutesRemaining - minutesPassed
        if (minuteDiff < 0) {
            minutesRemaining = minuteDiff + minutesPerHour
            hoursRemaining -= 1
        } else {
            minutesRemaining = minuteDiff
        }
        
        let hourDiff = hoursRemaining - hoursPassed
        if (hourDiff < 0) {
            hoursRemaining = 0
            minutesRemaining = 0
            secondsRemaining = 0
        } else {
            hoursRemaining = hourDiff
        }
    }

    func getTimeString() -> String {
        return String(format: "%02d:%02d:%02d", hoursRemaining, minutesRemaining, secondsRemaining)
    }
    
    func getPercentCompleted() -> Double {
        var remaining: Double = 0
        remaining += Double(secondsRemaining)
        remaining += Double(minutesRemaining * 60)
        remaining += Double(hoursRemaining * 3600)
        
        return 1 - (remaining / Double(timerDuration * 60))
    }
    
    func isComplete() -> Bool {
        return (hoursRemaining == 0 && minutesRemaining == 0 && secondsRemaining == 0)
    }
}
