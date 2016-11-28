//
//  ProjectsView.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class ProjectsView: NSObject, ProjectsPresenterDelegate {
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private weak var viewController: UIViewController?
    
    private let cellIdentifier = "ProjectTableViewCell"
    let presenter = ProjectsPresenter()
    
    func initialConfiguration() {
        self.presenter.delegate = self
//        self.presenter.viewController = self.viewController
        self.presenter.initialConfiguration()
        
        self.configureUserInterface()
    }
    
    // MARK: - Private methods
    
    private func configureUserInterface() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self.presenter, action: #selector(ProjectsPresenter.showCreateNewProjectDialog))
        self.viewController?.navigationItem.rightBarButtonItem = addBarButtonItem
        
        self.tableView?.estimatedRowHeight = 44.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.dataSource = self.presenter
        self.tableView?.delegate = self.presenter
    }
    
    // MARK: - ProjectsPresenterDelegate methods
    
    func cancelEdit() {
        self.tableView?.isEditing = false
    }
    
    func showCreateNewProjectDialog(with title: String, message messageText: String, create createTitle: String, cancel cancelTitle: String) {
        let alertController = UIAlertController(title: title, message: messageText, preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: createTitle, style: .default, handler: self.presenter.createHandler(for: alertController))
        createAction.isEnabled = false
        alertController.addAction(createAction)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        
        alertController.addTextField(configurationHandler: self.presenter.titleEditHandler(with: createAction))
        guard let textField = alertController.textFields?.first as UITextField? else {
            return
        }
        
        textField.placeholder = "Create new project"
        textField.autocapitalizationType = .sentences
        
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func createCell(with title: String?, and detailText: String?) -> UITableViewCell? {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = detailText
        
        return cell
    }
    
    func contentDidChange() {
        self.tableView?.endUpdates()
    }
    
    func contentWillChange() {
        self.tableView?.beginUpdates()
    }
    
    func contentChanged(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
