//
//  TimeRouter.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimeRouter: NSObject {
    weak var viewController: UIViewController?

    func presentTimeEditScreen(for timeID: NSManagedObjectID?, projectID: NSManagedObjectID?) {
        guard let timeEditViewController = self.viewController?.storyboard?.instantiateViewController(withIdentifier: "TimeEditViewController") as? TimeEditViewController else {
            return
        }

        timeEditViewController.currentTimeID = timeID
        timeEditViewController.currentProjectID = projectID
        self.viewController?.navigationController?.pushViewController(timeEditViewController, animated: true)
    }
}
