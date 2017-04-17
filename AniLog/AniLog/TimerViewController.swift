//
//  TimerViewController.swift
//  AniLog
//
//  Created by David Fang on 4/13/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    var updateTimer: Timer = Timer()
    var aniTimer: AniTimer!
    var timerDuration: Int16!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTimer() {
        aniTimer = AniTimer(duration: timerDuration)
        timerLabel.text = aniTimer.getTimeString()
        updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateAniTimer), userInfo: nil, repeats: true)
    }
    
    func updateAniTimer() {
        if (aniTimer.isComplete()) {
            endAniTimer()
        }
        
        aniTimer.updateRemainingTime()
        timerLabel.text = aniTimer.getTimeString()
    }
    
    func endAniTimer() {
        if (aniTimer.isComplete()) {
            // handle complete
            print("You are done!")
        }
        updateTimer.invalidate()
    }
    
    @IBAction func abortTask(_ sender: Any) {
        endAniTimer()
    }
}
