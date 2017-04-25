//
//  AppDelegate.swift
//  AniLog
//
//  Created by David Fang on 3/20/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil,
            { (_, observer, name, _, _) in
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "displayStatusIsLocked")
            }, "com.apple.springboard.lockcomplete" as CFString!, nil, .deliverImmediately)

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        let defaults = UserDefaults.standard
        let locked = defaults.bool(forKey: "displayStatusIsLocked")

        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            if let navigationController = tabBarController.selectedViewController as? AniLogNavigationController {
                if let timerViewController = navigationController.topViewController as? TimerViewController {
                    if (locked) {
                        timerViewController.pauseAniTimer()
                        defaults.set(Date(), forKey: "enterBackgroundTime")
                    } else {
                        if (timerViewController.timerIsRunning) {
                            timerViewController.stopAniTimer(isAbort: true)
                        }
                    }
                }
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

        let defaults = UserDefaults.standard
        let locked = defaults.bool(forKey: "displayStatusIsLocked")
        
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            if let navigationController = tabBarController.selectedViewController as? AniLogNavigationController {
                if let timerViewController = navigationController.topViewController as? TimerViewController {
                    if (locked) {
                        
                        print("Enter resume")
                        
                        let enterBackgroundDate: Date = defaults.object(forKey: "enterBackgroundTime") as! Date
                        timerViewController.aniTimer.fastForward(pauseTime: enterBackgroundDate, resTime: Date())
                        timerViewController.progressView.angle = 360.0 * timerViewController.aniTimer.getPercentCompleted()
                        timerViewController.timerLabel.text = timerViewController.aniTimer.getTimeString()
                        timerViewController.startAniTimer()
                    }
                }
            }
        }
        
        defaults.set(false, forKey: "displayStatusIsLocked")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: - Core Data Stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "myCore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving Support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

