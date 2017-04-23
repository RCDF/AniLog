//
//  TimerViewController.swift
//  AniLog
//
//  Created by David Fang on 4/13/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import CoreData

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
    
    /** Initializes the progress view with default view settings */
    func initProgressView() {
        progressView.startAngle = -90
        progressView.progressThickness = 0.2
        progressView.trackThickness = 0.2
        progressView.roundedCorners = true
        progressView.trackColor = UIColor.lightGray
        progressView.set(colors: UIColor.peach)
    }
    
    /**
        Creates a new timer with the given timerDuration, initializes
        the text, and starts the timer
     */
    func initTimer() {
        if let timerDuration = timerDuration {
            aniTimer = AniTimer(duration: timerDuration)
            timerLabel.text = aniTimer.getTimeString()
            updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateAniTimer), userInfo: nil, repeats: true)
        }
    }

    /**
        Updates the timer, updates the label, and moves the progress
        view appropriately
     */
    func updateAniTimer() {
        if (aniTimer.isComplete()) {
            endAniTimer()
        } else {
            aniTimer.updateRemainingTime()
            progressView.animate(toAngle: aniTimer.getPercentCompleted() * 360.0, duration: 1, completion: nil)
            timerLabel.text = aniTimer.getTimeString()
        }
    }

    /**
        Invalidates the timer. If the timer was completed (not an abort),
        adds the number of minutes completed to the daily log
     */
    func endAniTimer() {
        if (aniTimer.isComplete()) {
            if let dayLog = getLogFor(date: Date()) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let numMinutes = dayLog.totalMinutes

                dayLog.totalMinutes = numMinutes + timerDuration!
                appDelegate.saveContext()
            }
        }

        updateTimer.invalidate()
    }

    /**
        Force aborts the timer; for user
     
        - Parameter sender: button for force abort
     */
    @IBAction func abortTask(_ sender: UIButton) {
        updateTimer.invalidate()
    }
}
