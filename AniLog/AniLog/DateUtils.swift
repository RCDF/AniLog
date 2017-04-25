//
//  DateUtils.swift
//  AniLog
//
//  Created by David Fang on 4/22/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import Foundation

let daysInWeek: Int = 7
let daysInMonth: Int = 31
let daysInYear: Int = 365

extension Date {
    struct Gregorian {
        static let calendar = Calendar(identifier: .gregorian)
    }

    var startOfWeek: Date? {
        return Gregorian.calendar.date(from: Gregorian.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    
    var startOfDay: Date? {
        return NSCalendar.current.startOfDay(for: self)
    }
}

/**
    Returns the date string of the date in MMddyyyy format
 
    - Parameter date: The date for which to format
 */
func getDateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMddyyyy"
    
    return dateFormatter.string(from: date)
}

func dateStringPretty(_ dateString: String) -> String {
    let monthIndexEnd = dateString.index(dateString.startIndex, offsetBy: 2)
    let dayIndexEnd = dateString.index(monthIndexEnd, offsetBy: 2)
    let dayIndexRange = monthIndexEnd..<dayIndexEnd
    
    let month = dateString.substring(to: monthIndexEnd)
    let day = dateString.substring(with: dayIndexRange)
    
    return "\(month).\(day)"
}

/**
    Returns an array of date strings for the last specified
    days
 
    - Parameter days: The number of days to go back and retrieve
                      date strings for
 */
func getDateStringsFor(days: Int) -> [String] {
    var dateStrings: [String] = []
    let calendar = Calendar.current
    
    var date = calendar.startOfDay(for: Date())
    
    for _ in 1 ... days {
        dateStrings.append(getDateString(date: date))
        date = calendar.date(byAdding: .day, value: -1, to: date)!
    }
    
    return dateStrings.reversed()
}

/** Returns an array of date strings for the last seven days */
func getWeekDateStrings() -> [String] {
    return getDateStringsFor(days: daysInWeek)
}

/** Returns an array of date strings for the last thirty days */
func getMonthDateStrings() -> [String] {
    return getDateStringsFor(days: daysInMonth)
}

func getYearDateStrings() -> [String] {
    return getDateStringsFor(days: daysInYear)
}

