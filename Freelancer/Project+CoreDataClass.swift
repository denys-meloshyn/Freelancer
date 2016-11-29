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
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])

        var initDateComponents = calendar.dateComponents(units, from: Date())
        initDateComponents.year = 0
        initDateComponents.month = 0
        initDateComponents.day = 0
        initDateComponents.hour = 0
        initDateComponents.minute = 0
        initDateComponents.second = 0

        guard let registeredTimes = self.registeredTimes as? Set<LoggedTime> else {
            return nil
        }

        for time in registeredTimes {
            let timeDateComponents = time.spent()

            guard let year = timeDateComponents?.year, let month = timeDateComponents?.month, let day = timeDateComponents?.day, let hour = timeDateComponents?.hour, let minute = timeDateComponents?.minute, let second = timeDateComponents?.second else {
                continue
            }

            initDateComponents.year = initDateComponents.year! + year
            initDateComponents.month = initDateComponents.month! + month
            initDateComponents.day = initDateComponents.day! + day
            initDateComponents.hour = initDateComponents.hour! + hour
            initDateComponents.minute = initDateComponents.minute! + minute
            initDateComponents.second = initDateComponents.second! + second
        }

        return nil
    }
}
