//
//  ProjectsView.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class ProjectsView: NSObject, ProjectsPresenterDelegate, LifeCycleStateProtocol {
    weak var tableView: UITableView?
    var presenter: ProjectsPresenter
    weak var viewController: UIViewController?

    private let cellIdentifier = "ProjectTableViewCell"

    override init() {
        self.presenter = ProjectsPresenter()

        super.init()
    }
    
    func initialConfiguration() {
        self.presenter.delegate = self
        self.presenter.initialConfiguration()

        self.configureUserInterface()
    }
    
    // MARK: - Private methods
    
    private func configureUserInterface() {
        // Add button to create a new project
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self.presenter, action: #selector(ProjectsPresenter.showCreateNewProjectDialog))
        self.viewController?.navigationItem.rightBarButtonItem = addBarButtonItem

        self.tableView?.dataSource = self.presenter
        self.tableView?.delegate = self.presenter
    }

    // MARK: - LifeCycleStateProtocol methods

    func viewWillAppear(_ animated: Bool) {
        self.presenter.viewWillAppear(animated)
    }

    func viewDidAppear(_ animated: Bool) {

    }

    func viewWillDisappear(_ animated: Bool) {

    }

    func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: - ProjectsPresenterDelegate methods

    func refreshContent() {
        self.tableView?.reloadData()
    }
    
    func cancelEdit() {
        self.tableView?.isEditing = false
    }
    
    func showCreateNewProjectDialog(with title: String, message messageText: String, create createTitle: String, cancel cancelTitle: String, placeholder textPlaceholder: String) {
        // Create alert controller with text field
        let alertController = UIAlertController(title: title, message: messageText, preferredStyle: .alert)

        // Configure create button
        let createAction = UIAlertAction(title: createTitle, style: .default, handler: self.presenter.createHandler(for: alertController))
        createAction.isEnabled = false
        alertController.addAction(createAction)

        // Configure cancel button
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        
        alertController.addTextField(configurationHandler: self.presenter.titleEditHandler(with: createAction))
        guard let textField = alertController.textFields?.first as UITextField? else {
            return
        }
        
        textField.placeholder = textPlaceholder
        textField.autocapitalizationType = .sentences
        
        self.viewController?.present(alertController, animated: true, completion: nil)
    }

    func showDeleteDialog(with title: String, message: String, cancelTitle: String, deleteTitle: String, indexPath: IndexPath) {
        // Create alert controller to delete project
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Create delete button
        let deleteAction = UIAlertAction(title: deleteTitle, style: .destructive, handler: self.presenter.confirmDeleteHandler(with: indexPath))
        // Create cancel button
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: self.presenter.cancelDeleteHandler())

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        self.viewController?.present(alertController, animated: true, completion: nil)
    }

    func createDeleteProjectRowAction(with title: String, and handler: @escaping (UITableViewRowAction, IndexPath) -> Void) -> UITableViewRowAction {
        // Create row view to delete project
        let deleteAction = UITableViewRowAction(style: .destructive, title: title, handler: handler)

        return deleteAction
    }

    func createCell(with title: String?, and detailText: String?) -> UITableViewCell? {
        // Create cell for project
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = detailText
        
        return cell
    }
    
    func didChangeContent() {
        self.tableView?.endUpdates()
    }
    
    func willChangeContent() {
        self.tableView?.beginUpdates()
    }
    
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView?.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        case .delete:
            if let indexPath = indexPath {
                self.tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
            
        case .update:
            if let indexPath = indexPath {
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
            
        default:
            break
        }
    }
}
