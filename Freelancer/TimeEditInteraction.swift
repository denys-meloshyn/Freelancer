//
//  TimeEditInteraction.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimeEditInteraction {
    private var currentProject: Project?
    private var managedObjectContext: NSManagedObjectContext
    
    var currentTime: LoggedTime?
    var currentTimeID: NSManagedObjectID?
    var currentProjectID: NSManagedObjectID?

    init() {
        self.managedObjectContext = ModelManager.createChildrenManagedObjectContext(from: ModelManager.sharedInstance.managedObjectContext)
    }

    func initialConfiguration() {
        guard let currentProjectID = self.currentProjectID else {
            return
        }

        self.currentProject = self.managedObjectContext.object(with: currentProjectID) as? Project

        if let currentTimeID = self.currentTimeID {
            self.currentTime = self.managedObjectContext.object(with: currentTimeID) as? LoggedTime
        } else {
            self.currentTime = LoggedTime(context: self.managedObjectContext)
            self.currentTime?.start = NSDate()
            self.currentProject?.addToRegisteredTimes(self.currentTime!)
        }
        
        ModelManager.saveContext(self.managedObjectContext)
    }

    func saveTimeEditChanges() {
        ModelManager.saveChildren(self.managedObjectContext)
    }
    
    func increaseTimeOneSecond() {
        var initDateComponents = DateComponents()
        initDateComponents.second = 1
        
        self.changeTime(on: initDateComponents)
    }

    func addDate(_ date: Date) {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.hour, .minute, .second])

        let dateComponents = calendar.dateComponents(units, from: date)
        self.changeTime(on: dateComponents)
    }

    func substructDate(_ date: Date) {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.hour, .minute, .second])

        var dateComponents = calendar.dateComponents(units, from: date)

        guard let hour = dateComponents.hour, let minute = dateComponents.minute else {
            return
        }

        dateComponents.hour = -hour
        dateComponents.minute = -minute

        self.changeTime(on: dateComponents)

        guard let currentSpentTime = self.currentTime?.spent() else {
            return
        }

        guard let currentHour = currentSpentTime.hour, let currentMinute = currentSpentTime.minute, let currentSecond = currentSpentTime.second else {
            return
        }

        if currentHour < 0 || currentMinute < 0 || currentSecond < 0 {
            self.currentTime?.finish = self.currentTime?.start
        }
    }

    func generateDate(with hours: Int, minute minutes: Int, second seconds: Int) -> Date? {
        let calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = minutes
        dateComponents.second = seconds

        return calendar.date(from: dateComponents)
    }
    
    private func changeTime(on date: DateComponents) {
        guard let finishDate = self.currentTime?.finish else {
            return
        }
        
        let calendar = Calendar.current
        self.currentTime?.finish = calendar.date(byAdding: date, to: finishDate as Date) as NSDate?
    }
}
