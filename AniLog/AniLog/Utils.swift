//
//  Utils.swift
//  AniLog
//
//  Created by David Fang on 4/16/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import CoreData

func trueMod(_ a: Int16, _ n: Int16) -> Int16 {
    let r = a % n
    return r >= 0 ? r : r + n
}

func getTagColor(_ tag_num: Int16) -> UIColor {
    switch tag_num {
    case 0:
        return UIColor.sunsetOrange
    case 1:
        return UIColor.deepseaBlue
    case 2:
        return UIColor.regalRed
    case 3:
        return UIColor.softPurple
    case 4:
        return UIColor.forestGreen
    case 5:
        return UIColor.goldenYellow
    default:
        return UIColor.lightGray    // should never enter
    }
}

func getDateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMddyyyy"

    return dateFormatter.string(from: date)
}

func getLogFor(date: Date) -> Log? {
    let dateString = getDateString(date: date)
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

