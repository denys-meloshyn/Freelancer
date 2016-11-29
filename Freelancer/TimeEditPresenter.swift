//
//  TimeEditPresenter.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimeEditPresenter: NSObject {
    let interaction = TimeEditInteraction()
    var currentTimeID: NSManagedObjectID?
    var currentProjectID: NSManagedObjectID?

    func initialConfiguration() {
        self.interaction.currentTimeID = self.currentTimeID
        self.interaction.currentProjectID = self.currentProjectID
    }

    func saveChanges() {
        self.interaction.saveTimeEditChanges()
    }
}
