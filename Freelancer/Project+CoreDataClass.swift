//
//  Project+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 28.11.16.
//
//

import Foundation
import CoreData

@objc(Project)
public class Project: NSManagedObject {
    func totalSpent() -> DateComponents? {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.hour, .minute, .second])

        guard let registeredTimes = self.registeredTimes as? Set<LoggedTime> else {
            return nil
        }
        
        let startDate = NSDate()
        var totalDate = startDate
        for time in registeredTimes {
            guard let finish = time.finish, let start = time.start else {
                continue
            }
            
            totalDate = totalDate.addingTimeInterval(finish.timeIntervalSince(start as Date))
        }

        let dateComponents = calendar.dateComponents(units, from: startDate as Date, to: totalDate as Date)
        return dateComponents
    }
}
