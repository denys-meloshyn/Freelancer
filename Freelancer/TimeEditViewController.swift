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
    @IBOutlet private var timeEditView: TimeEditView?

    var currentTimeID: NSManagedObjectID?
    var currentProjectID: NSManagedObjectID?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.timeEditView?.currentTimeID = self.currentTimeID
        self.timeEditView?.currentProjectID = self.currentProjectID
        self.timeEditView?.initialConfiguration()
    }
}
