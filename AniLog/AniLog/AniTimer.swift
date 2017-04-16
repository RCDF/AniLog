//
//  AniTimer.swift
//  AniLog
//
//  Created by David Fang on 4/16/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import Foundation

class AniTimer {
    
    var timerDuration: UInt16
    var hoursRemaining: UInt16
    var minutesRemaining: UInt16
    var secondsRemaining: UInt16
    var complete: Bool
    
    init(duration: UInt16) {
        self.timerDuration = duration
        self.hoursRemaining = duration / 60
        self.minutesRemaining = duration - (60 * hoursRemaining)
        self.secondsRemaining = 0
        self.complete = false
    }
    
    func updateRemainingTime() {
        if (!complete) {

            if (secondsRemaining == 0) {
                minutesRemaining -= 1
                secondsRemaining = 59
            } else {
                secondsRemaining -= 1
            }
            
            if (minutesRemaining == 0) {
                hoursRemaining -= 1
                minutesRemaining = 59
            }
            
            complete = (hoursRemaining == 0 && minutesRemaining == 0 && secondsRemaining == 0)
        }
    }
    
    func getTimeString() -> String {
        return String(format: "%02d:%02d:%02d", hoursRemaining, minutesRemaining, secondsRemaining)
    }
    
    func isComplete() -> Bool {
        return complete
    }
}
