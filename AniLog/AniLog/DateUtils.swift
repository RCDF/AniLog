//
//  DateUtils.swift
//  AniLog
//
//  Created by David Fang on 4/22/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import Foundation

let secondsPerMinute: Int16 = 60
let minutesPerHour: Int16 = 60

let daysInWeek: Int = 7
let daysInMonth: Int = 31
let daysInYear: Int = 365
let monthsInYear: Int = 12

extension Date {
    struct Gregorian {
        static let calendar = Calendar(identifier: .gregorian)
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!.startOfDay
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return Calendar.current.date(byAdding: components, to: self.startOfMonth)!.startOfDay
    }
    
    var startOfWeek: Date? {
        return Gregorian.calendar.date(from: Gregorian.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    
    var startOfDay: Date {
        return NSCalendar.current.startOfDay(for: self)
    }
    
    var prettyString: String {
        let dateString = getDateString(date: self)
        let monthIndexEnd = dateString.index(dateString.startIndex, offsetBy: 2)
        let dayIndexEnd = dateString.index(monthIndexEnd, offsetBy: 2)
        let dayIndexRange = monthIndexEnd..<dayIndexEnd
        
        let month = dateString.substring(to: monthIndexEnd)
        let day = dateString.substring(with: dayIndexRange)
        
        return "\(month).\(day)"
    }

    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        
        return dateFormatter.string(from: date)
    }
}

/**
    Returns an array of date strings for the last specified
    days
 
    - Parameter days: The number of days to go back and retrieve
                      date strings for
 */
func getDatesFor(days: Int) -> [Date] {
    var dates: [Date] = []
    let calendar = Calendar.current
    
    var date = calendar.startOfDay(for: Date())

    for _ in 1 ... days {
        dates.append(date.startOfDay)
        date = calendar.date(byAdding: .day, value: -1, to: date)!
    }
    
    return dates.reversed()
}

/**
    Return the Date for the month for the given month string
 
    - Parameter monthString: The month to get a date for, of the
                             form MMyyyy
 */
func getMonthFromString(monthString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMyyyy"
    return dateFormatter.date(from: monthString)
}


/** Returns an array of dates for the last seven days */
func getWeekDates() -> [Date] {
    return getDatesFor(days: daysInWeek)
}

/** Returns an array of dates for the last thirty days */
func getMonthDates() -> [Date] {
    return getDatesFor(days: daysInMonth)
}

/** Return an array of dates for the last 365 days */
func getYearDates() -> [Date] {
    return getDatesFor(days: daysInYear)
}

