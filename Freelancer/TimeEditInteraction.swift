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
            self.currentTime?.finish = NSDate()
            self.currentProject?.addToRegisteredTimes(self.currentTime!)
        }
    }

    func saveTimeEditChanges() {
        ModelManager.saveChildren(self.managedObjectContext)
    }
    
    func increaseTimeOneSecond() {
        var dateComponents = DateComponents()
        dateComponents.second = 1
        
        self.currentTime?.finish = self.calculateTime(with: dateComponents)
    }

    func addDate(_ date: Date) {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.hour, .minute, .second])
        
        // TODO: add max limit
        let dateComponents = calendar.dateComponents(units, from: date)
        self.currentTime?.finish = self.calculateTime(with: dateComponents)
    }

    func subtractDate(_ date: Date) {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.hour, .minute, .second])

        var dateComponents = calendar.dateComponents(units, from: date)

        guard let hour = dateComponents.hour, let minute = dateComponents.minute else {
            return
        }

        dateComponents.hour = -hour
        dateComponents.minute = -minute
        let newDate = self.calculateTime(with: dateComponents)

        guard let startDate = self.currentTime?.start else {
            return
        }

        // Prevent from negative value
        if newDate?.compare(startDate as Date) == ComparisonResult.orderedAscending {
            self.currentTime?.finish = self.currentTime?.start
        } else {
            self.currentTime?.finish = newDate
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
    
    // MARK: - Private functions
    
    private func calculateTime(with dateComponents: DateComponents) -> NSDate? {
        let calendar = Calendar.current

        guard let time = self.currentTime?.finish else {
            return nil
        }

        return calendar.date(byAdding: dateComponents, to: time as Date) as NSDate?
    }
}
