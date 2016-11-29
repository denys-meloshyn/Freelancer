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

        var initDateComponents = calendar.dateComponents(units, from: Date())
        initDateComponents.hour = 0
        initDateComponents.minute = 0
        initDateComponents.second = 0

        guard let registeredTimes = self.registeredTimes as? Set<LoggedTime> else {
            return nil
        }

        for time in registeredTimes {
            let timeDateComponents = time.spent()

            guard let hour = timeDateComponents?.hour, let minute = timeDateComponents?.minute, let second = timeDateComponents?.second else {
                continue
            }

            initDateComponents.hour = initDateComponents.hour! + hour
            initDateComponents.minute = initDateComponents.minute! + minute
            initDateComponents.second = initDateComponents.second! + second
        }

        return nil
    }
}
