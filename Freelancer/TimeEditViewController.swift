//
//  TimeEditViewController.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol LifeCycleStateProtocol: class {
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}

class TimeEditViewController: UIViewController {
    @IBOutlet private var timeEditView: TimeEditView?

    var currentTimeID: NSManagedObjectID?
    var currentProjectID: NSManagedObjectID?
    private var interaction: TimeEditInteraction?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.interaction = TimeEditInteraction()
        self.timeEditView?.presenter.configure(with: self.interaction)

        self.timeEditView?.currentTimeID = self.currentTimeID
        self.timeEditView?.currentProjectID = self.currentProjectID
        self.timeEditView?.initialConfiguration()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.timeEditView?.viewWillDisappear(animated)
    }
}
