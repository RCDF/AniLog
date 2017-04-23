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
    private var complete: Bool
    
    init(duration: Int16) {
        self.timerDuration = duration
        self.hoursRemaining = duration / 60
        self.minutesRemaining = duration - (60 * hoursRemaining)
        self.secondsRemaining = 0
        self.complete = false
    }
    
    func updateRemainingTime() {
        if (!complete) {
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

            complete = (hoursRemaining == 0 && minutesRemaining == 0 && secondsRemaining == 0)
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
        return complete
    }
}
