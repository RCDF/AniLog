//
//  LogUtils.swift
//  AniLog
//
//  Created by David Fang on 4/22/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import CoreData

/**
    Searches through CoreData for the Log with the given dateString
    key. If one does not yet exist, a new Log is created for the given
    dateString.
 
    - Important: When you query for a range of dates using
                 any of the DateUtils functions, recall that
                 you still need to call a getLog function
                 to get the actual Log instance
 
    - Parameter dateString: The unique dateString key for the Log
                            to retrieve
 */
func getLogFromString(dateString: String) -> Log? {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let filterPred = NSPredicate(format: "date == %@", argumentArray: [dateString])
    let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
    fetchRequest.predicate = filterPred
    fetchRequest.fetchLimit = 1
    
    do {
        let fetchResults = try context.fetch(fetchRequest)
        var dayLog: Log?
        
        if (fetchResults.count < 1) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            dayLog = Log(context: context)
            dayLog?.setValue(dateString, forKey: "date")
            appDelegate.saveContext()
            
        } else {
            dayLog = fetchResults[0]
        }

        return dayLog
        
    } catch {
        return nil
    }
}

/** 
    Returns an array of logs with the given dateStrings
 
    - Parameter dateStrings: A list of dateString keys to query for
 */
func getLogsFromStrings(dateStrings: [String]) -> [Log] {
    var logs: [Log] = []

    for str in dateStrings {
        if let log = getLogFromString(dateString: str) {
            logs.append(log)
        }
    }
    
    return logs
}

/* Retrieves the log for the given date */
func getLogFor(date: Date) -> Log? {
    let dateString = getDateString(date: date)
    return getLogFromString(dateString: dateString)
}

/**
    Retrieve the average number of hours committed based on
    all the logs for the MONTH
 
    - Parameter year: the year to query, of the form YYYY
    - Parameter month: the month to query
 */
func getAvgHoursForMonth(year: Int, month: Int) -> Double {
    let bottomRange: String = String(format: "%02d00%d", month, year)
    print(bottomRange)
    return 0
    
}


