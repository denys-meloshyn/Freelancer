//
//  TimesViewController.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimesViewController: UIViewController {
    private var currentProject: Project?
    private let managedObjectContext = ModelManager.sharedInstance.managedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<LoggedTime>?

    var currentProjectID: NSManagedObjectID? {
        didSet {
            guard let currentProjectID = self.currentProjectID else {
                return
            }

            self.currentProject = self.managedObjectContext.object(with: currentProjectID) as? Project
            self.fetchedResultsController = ModelManager.timeFetchedResultController(for: currentProjectID, with: self.managedObjectContext)

            do {
                try self.fetchedResultsController?.performFetch()
            }
            catch {

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
