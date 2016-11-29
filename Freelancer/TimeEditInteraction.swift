//
//  TimeEditInteraction.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimeEditInteraction: NSObject {
    private var currentProject: Project?
    private let managedObjectContext = ModelManager.createChildrenManagedObjectContext(from: ModelManager.sharedInstance.managedObjectContext)
    
    var currentTime: LoggedTime?
    var currentTimeID: NSManagedObjectID?
    var currentProjectID: NSManagedObjectID?

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
        
        ModelManager.saveChildrenManagedObjectContext(self.managedObjectContext)
    }

    func saveTimeEditChanges() {
        ModelManager.saveContext(self.managedObjectContext)
    }
    
    func increaseTimeOneSecond() {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.second])
        
        var initDateComponents = calendar.dateComponents(units, from: Date())
        initDateComponents.second = 1
        
        guard let finishDate = self.currentTime?.finish else {
            return
        }
        
        self.currentTime?.finish = calendar.date(byAdding: initDateComponents, to: finishDate as Date) as NSDate?
    }
    
    private func increaseTime(on date: DateComponents) {
        
    }
}
