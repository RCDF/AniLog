//
//  TimerViewController.swift
//  AniLog
//
//  Created by David Fang on 4/13/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

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
    var statusHidden: Bool = false
    var timerIsRunning: Bool = false
    
    /** Animates status bar being hidden */
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    /** Hides the status bar */
    override var prefersStatusBarHidden: Bool {
        return statusHidden
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.fadeStatusBar()
    }
    
    func initPickerView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
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
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.pickerView.alpha = 0
            self.startButton.alpha = 0
            self.startButton.isUserInteractionEnabled = false
        }, completion: {
            (finished: Bool) -> Void in
            //Fade In
            self.setTimerDuration()
            self.initTimer()
            UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.startAniTimer()
                self.progressView.alpha = 1
                self.abortButton.alpha = 1
                self.abortButton.isUserInteractionEnabled = true
            }, completion: { (finished: Bool) -> Void in
                self.scheduleNotification()
            })
        })
    }
    

    /**
        Fires off the updateTimer that runs our AniTimer
     */
    func startAniTimer() {
        timerIsRunning = true
        updateAniTimer()
        updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateAniTimer), userInfo: nil, repeats: true)
    }
    
    /**
        Updates the timer, updates the label, and moves the progress
        view appropriately
     */
    func updateAniTimer() {
        if (aniTimer.isComplete()) {
            stopAniTimer(isAbort: false)
        } else {
            aniTimer.updateRemainingTime()
            progressView.animate(toAngle: aniTimer.getPercentCompleted() * 360.0, duration: 1, completion: nil)
            timerLabel.text = aniTimer.getTimeString()
        }
    }

    func pauseAniTimer() {
        timerIsRunning = false
        updateTimer.invalidate()
        progressView.pauseAnimation()
    }
    
    /**
        Invalidates the timer. If the timer was completed (not an abort),
        adds the number of minutes completed to the daily log
     */
    func stopAniTimer(isAbort: Bool) {
        timerIsRunning = false
        updateTimer.invalidate()
        progressView.pauseAnimation()
        
        if (isAbort) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            displayAbortWarning()
        } else if (aniTimer.isComplete()) {
            if let dayLog = getLogFor(date: Date()) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let numHours = dayLog.totalHours

                dayLog.totalHours = numHours + Double(timerDuration! / 60)
                appDelegate.saveContext()
            }
        }
    }

    /**
        Force aborts the timer; for user
     
        - Parameter sender: button for force abort
     */
    @IBAction func abortTask(_ sender: UIButton) {
        stopAniTimer(isAbort: true)
    }
    
    /**
        Begins to animate hiding the status bar
    */
    func fadeStatusBar() {
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.statusHidden = !self.statusHidden
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: - Alert Generating Functions
    
    func displayAbortWarning() {
        let alert = UIAlertController(title: "Aborting focus session", message: "Your focus session was aborted either manually or by exiting the app.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Exit session", style: UIAlertActionStyle.destructive, handler:  { action in
            self.performSegue(withIdentifier: "timerToTaskList", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Local Notifications

    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Time for a breather!"
        content.body = "You've successfully completed your focus session!"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(Int(timerDuration! * 60)), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.delegate = self
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print (error)
            }
        })
    }
}

extension TimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        print("Tapped in notification")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("Notification being triggered")
        completionHandler([.alert, .sound, .badge])
    }
}

