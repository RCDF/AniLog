//
//  TimerViewController.swift
//  AniLog
//
//  Created by David Fang on 4/13/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import Foundation

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
        
        timeDuration = 1
        initPickerView()
        initProgressView()
        initTimer()
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
    
    @IBAction func startTask(_ sender: Any) {
        //Fade Out
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.pickerView.alpha = 0
            self.startButton.alpha = 0
            self.startButton.isUserInteractionEnabled = false
        }, completion: {
            (finished: Bool) -> Void in
            //Fade In
            UIView.animate(withDuration: 0.8, delay: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.progressView.alpha = 1
                self.abortButton.alpha = 1
                self.abortButton.isUserInteractionEnabled = true
            }, completion: nil)
        })
        initTimer()
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
