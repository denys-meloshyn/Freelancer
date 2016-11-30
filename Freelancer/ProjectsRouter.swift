//
//  ProjectsRouter.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class ProjectsRouter {
    private weak var viewController: UIViewController?

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func presentLoggedTimes(for projectID: NSManagedObjectID) {
        guard let timesViewController = self.viewController?.storyboard?.instantiateViewController(withIdentifier: "TimesViewController") as? TimesViewController else {
            return
        }

        timesViewController.currentProjectID = projectID
        self.viewController?.navigationController?.pushViewController(timesViewController, animated: true)
    }
}
