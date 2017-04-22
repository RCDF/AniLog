//
//  TimerViewController.swift
//  AniLog
//
//  Created by David Fang on 4/13/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: KDCircularProgress!

    var updateTimer: Timer = Timer()
    var aniTimer: AniTimer!
    var task: Task!
    var timerDuration: Int16?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.isHidden = true
        // progressView.isHidden = true
        
        timerDuration = 1
        initProgressView()
        initTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initProgressView() {
        progressView.startAngle = -90
        progressView.progressThickness = 0.2
        progressView.trackThickness = 0.2
        progressView.roundedCorners = true
        progressView.trackColor = UIColor.lightGray
        progressView.set(colors: UIColor.peach)
    }
    
    func initTimer() {
        if let timerDuration = timerDuration {
            aniTimer = AniTimer(duration: timerDuration)
            timerLabel.text = aniTimer.getTimeString()
            updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateAniTimer), userInfo: nil, repeats: true)
            progressView.animate(toAngle: 360.0, duration: TimeInterval(Int(timerDuration) * 60), completion: nil)
        }
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
