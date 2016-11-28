//
//  ProjectsView.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit

class ProjectsView: NSObject, ProjectsPresenterDelegate {
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private weak var viewController: UIViewController?
    
    let presenter = ProjectsPresenter()
    
    func initialConfiguration() {
        self.presenter.delegate = self
//        self.presenter.viewController = self.viewController
//        self.presenter.initialConfiguration()
        
        self.configureUserInterface()
    }
    
    // MARK: - Private methods
    
    private func configureUserInterface() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self.presenter, action: #selector(ProjectsPresenter.showCreateNewProjectDialog))
        self.viewController?.navigationItem.rightBarButtonItem = addBarButtonItem
        
        self.tableView?.estimatedRowHeight = 44.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - ProjectsPresenterDelegate methods
    
    func cancelEdit() {
        self.tableView?.isEditing = false
    }
    
    func showCreateNewProjectDialog(with title: String, message messageText: String, create createTitle: String, cancel cancelTitle: String) {
        let alertController = UIAlertController(title: title, message: messageText, preferredStyle: UIAlertControllerStyle.alert)
        
        let createAction = UIAlertAction(title: createTitle, style: .default, handler: self.presenter.createHandler(for: alertController))
        createAction.isEnabled = false
        alertController.addAction(createAction)
        
        //        let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: model.cancelHandler)
        //        alertController.addAction(cancelAction)
        
        //        alertController.addTextField(configurationHandler: model.editTitleHandler)
        
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
}
