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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var abortButton: RoundButton!
    @IBOutlet weak var taskToComplete: UILabel!
    @IBOutlet weak var startButton: RoundButton!

    var updateTimer: Timer = Timer()
    var aniTimer: AniTimer!
    var task: Task!
    var timerDuration: Int16?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.alpha = 1
        startButton.alpha = 1
        startButton.isUserInteractionEnabled = true

        progressView.alpha = 0
        abortButton.alpha = 0
        abortButton.isUserInteractionEnabled = false
        
        taskToComplete.text = task.taskDescription
        
        initPickerView()
        initProgressView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPickerView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        if let date = dateFormatter.date(from: "00:30") {
            pickerView.setDate(date, animated: true)
        }
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
        }
    }
    
    func setTimerDuration() {
        let hours = Calendar.current.component(.hour, from: self.pickerView.date)
        let minutes = Calendar.current.component(.minute, from: self.pickerView.date)
        let int_h: Int = hours
        let int_m: Int = minutes
        let hours_int16: Int16 = Int16(int_h)
        let minutes_int16: Int16 = Int16(int_m)
        let hours_to_min = hours_int16 * 60
        self.timerDuration = hours_to_min + minutes_int16
    }
    
    @IBAction func startTask(_ sender: Any) {
        //Fade Out
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.pickerView.alpha = 0
            self.startButton.alpha = 0
            self.startButton.isUserInteractionEnabled = false
        }, completion: {
            (finished: Bool) -> Void in
            //Fade In
            self.setTimerDuration()
            self.initTimer()
            UIView.animate(withDuration: 0.8, delay: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.progressView.alpha = 1
                self.abortButton.alpha = 1
                self.abortButton.isUserInteractionEnabled = true
            }, completion: {
                (finished: Bool) -> Void in
                self.startAniTimer()
            })
        })
    }
    

    /**
        Fires off the updateTimer that runs our AniTimer
    */
    func startAniTimer() {
        updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateAniTimer), userInfo: nil, repeats: true)
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
                let numHours = dayLog.totalHours

                dayLog.totalHours = numHours + Double(timerDuration! / 60)
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
