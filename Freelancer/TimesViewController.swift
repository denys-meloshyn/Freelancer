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
    @IBOutlet private var timeView: TimesView?

    var currentProjectID: NSManagedObjectID?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.timeView?.currentProjectID = self.currentProjectID
        self.timeView?.initialConfiguration()
    }
}
