//
//  ProjectsViewController.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {
    @IBOutlet var projectsView: ProjectsView?

    var router: ProjectsRouter?
    var interaction: ProjectsInteraction?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.router = ProjectsRouter(with: self)
        self.interaction = ProjectsInteraction()
        self.projectsView?.presenter.configure(with: self.interaction, and: self.router)

        self.projectsView?.initialConfiguration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.projectsView?.viewWillAppear(animated)
    }
}
