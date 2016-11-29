//
//  ProjectsViewController.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {
    @IBOutlet private var projectsView: ProjectsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.projectsView?.initialConfiguration()
    }
}
