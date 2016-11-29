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
    private var currentTime: LoggedTime?
    private var currentProject: Project?
    private let managedObjectContext = ModelManager.createChildrenManagedObjectContext(from: ModelManager.sharedInstance.managedObjectContext)

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
            self.currentTime?.title = "Title"
            self.currentTime?.start = NSDate()
            self.currentProject?.addToRegisteredTimes(self.currentTime!)
        }

        self.currentTime?.finish = NSDate()
        ModelManager.saveChildrenManagedObjectContext(self.managedObjectContext)
        print("\(self.currentTime?.spent())")
    }

    func saveTimeEditChanges() {
        ModelManager.saveContext(self.managedObjectContext)
    }
}
