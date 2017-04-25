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
    Searches through CoreData for the Log with the given date key.
    If one does not yet exist, a new Log is created for the given
    date.
     
    - Important: When you query for a range of dates using
    any of the DateUtils functions, recall that
    you still need to call a getLog function
    to get the actual Log instance
     
    - Parameter date: The unique dateString key for the Log
                            to retrieve
 */
func getLogFor(date: Date) -> Log? {
    let startOfDate = date.startOfDay
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let filterPred = NSPredicate(format: "date == %@", argumentArray: [startOfDate])
    let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
    fetchRequest.predicate = filterPred
    fetchRequest.fetchLimit = 1
    
    do {
        let fetchResults = try context.fetch(fetchRequest)
        var dayLog: Log?
        
        if (fetchResults.count < 1) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            dayLog = Log(context: context)
            dayLog?.setValue(startOfDate, forKey: "date")

            print("Created new log: \(dayLog!.date)")
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
    Returns an array of logs with the given dates
 
    - Parameter dates: A list of date keys to query for
 */
func getLogsForDates(dates: [Date]) -> [Log] {
    var logs: [Log] = []

    for date in dates {
        if let log = getLogFor(date: date) {
            logs.append(log)
        }
    }
    
    return logs
}

/**
    Retrieve the average number of hours committed based on
    all the logs for the MONTH
 
    - Parameter year: the year to query, of the form YYYY
    - Parameter month: the month to query
 */
func getAvgHoursForMonth(year: Int, month: Int) -> Double {
    let monthString = String(format: "%02d%d", month, year)
    if let month = getMonthFromString(monthString: monthString) {
        let range = Calendar.current.range(of: .day, in: .month, for: month)!
        let numDays = range.count

        let monthStart = month.startOfMonth
        let monthEnd = month.endOfMonth

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", monthStart as CVarArg, monthEnd as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            let hours = results.map({ (log) -> Double in
                log.totalHours
            })
            
            let sumHours = hours.reduce(0, +)
            return sumHours / Double(numDays)
        } catch {
            return 0
        }
    }
    
    return 0
}
