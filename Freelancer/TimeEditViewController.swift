//
//  TimeEditViewController.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimeEditViewController: UIViewController {
    private var currentTime: LoggedTime?
    private let managedObjectContext = ModelManager.createChildrenManagedObjectContext(from: ModelManager.sharedInstance.managedObjectContext)

    var currentTimeID: NSManagedObjectID?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentTimeID = self.currentTimeID {
            self.currentTime = self.managedObjectContext.object(with: currentTimeID) as? LoggedTime
        } else {
            self.currentTime = LoggedTime(context: self.managedObjectContext)
            self.currentTime?.title = "Title"
            self.currentTime?.start = NSDate()
        }

        self.currentTime?.finish = NSDate()
        ModelManager.saveChildrenManagedObjectContext(self.managedObjectContext)
        print("\(self.currentTime?.spent())")
    }
}
