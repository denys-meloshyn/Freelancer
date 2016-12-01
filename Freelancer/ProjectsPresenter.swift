//
//  ProjectsPresenter.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol ProjectsPresenterDelegate: ContentInteractionDelegate, LifeCycleStateProtocol {
    func cancelEdit()
    func refreshContent()
    func createCell(with title: String?, and detailText: String?) -> UITableViewCell?
    func showDeleteDialog(with title: String, message: String, cancelTitle: String, deleteTitle: String, indexPath: IndexPath)
    func showCreateNewProjectDialog(with title:String, message messageText: String, create createTitle: String, cancel cancelTitle: String, placeholder textPlaceholder: String)
    func createDeleteProjectRowAction(with title: String, and handler: @escaping (UITableViewRowAction, IndexPath) -> Swift.Void) -> UITableViewRowAction
}

class ProjectsPresenter: NSObject, UITableViewDelegate, UITableViewDataSource, ProjectsInteractionDelegate {
    weak var router: ProjectsRouter?
    weak var interaction: ProjectsInteraction?
    weak var delegate: ProjectsPresenterDelegate?

    func configure(with interaction: ProjectsInteraction?, and router: ProjectsRouter?) {
        self.router = router
        self.interaction = interaction
    }

    func initialConfiguration() {
        self.interaction?.initialConfiguration()
        self.interaction?.delegate = self
    }

    // MARK: - LifeCycleStateProtocol methods

    func viewWillAppear(_ animated: Bool) {
        self.delegate?.refreshContent()
    }

    func viewDidAppear(_ animated: Bool) {

    }

    func viewWillDisappear(_ animated: Bool) {

    }

    func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = self.interaction?.numberOfProjects() else {
            return 0
        }

        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = self.interaction?.project(for: indexPath)
        let spentTime = Constants.formatLoggedTime(dateComponents: project?.totalSpent())

        // Ask delegate to create a cell view
        guard let cell = self.delegate?.createCell(with: project?.title, and: spentTime) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let project = self.interaction?.project(for: indexPath) else {
            return
        }

        // Open selected project with logged times
        self.router?.presentLoggedTimes(for: project.objectID)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteHandler = { (action: UITableViewRowAction, indexPath: IndexPath) in
            self.delegate?.showDeleteDialog(with: "Delete", message: "Do you want to delete the project?", cancelTitle: "Cancel", deleteTitle: "Delete", indexPath: indexPath)

            return
        }

        guard let deleteAction = self.delegate?.createDeleteProjectRowAction(with: "Delete", and: deleteHandler) else {
            return nil
        }

        return [deleteAction]
    }
    
    // MARK: - Private methods
    
    private func isTitleValid(_ title: String?) -> Bool {
        // Avoid empty title for project
        let trimmedTitle = self.removeWhiteSpacesIn(eventTitle: title)
        
        if let text = trimmedTitle, text.characters.count == 0 {
            return false
        }
        
        return true
    }
    
    private func removeWhiteSpacesIn(eventTitle title: String?) -> String? {
        let trimmedTitle = title?.trimmingCharacters(in: .whitespaces)
        
        return trimmedTitle
    }
    
    // MARK: - Public methods
    
    func createHandler(for alertController: UIAlertController) -> ((UIAlertAction) -> Void)? {
        let handler = {(alertAction: UIAlertAction) in
            guard let titleTextField = alertController.textFields?.first as UITextField? else {
                return
            }

            // Remove all white spaces from text field
            titleTextField.text = self.removeWhiteSpacesIn(eventTitle: titleTextField.text)
            
            self.delegate?.cancelEdit()
            // Check if input name is valid
            if !self.isTitleValid(titleTextField.text) {
                return
            }


            guard let newProject = self.interaction?.createNewProject() else {
                return
            }

            // Configure new project and present it
            newProject.title = titleTextField.text
            self.interaction?.saveProjectChanges()
            self.router?.presentLoggedTimes(for: newProject.objectID)
            
            return
        }
        
        return handler
    }

    func confirmDeleteHandler(with indexPath: IndexPath) -> ((UIAlertAction) -> Swift.Void)? {
        guard let project = self.interaction?.project(for: indexPath) else {
            return nil
        }

        let handler = { (alertAction: UIAlertAction) in
            self.interaction?.delete(project)
            self.delegate?.cancelEdit()

            return
        }

        return handler
    }

    func cancelDeleteHandler() -> ((UIAlertAction) -> Swift.Void)? {
        let handler = { (alertAction: UIAlertAction) in
            self.delegate?.cancelEdit()

            return
        }

        return handler
    }

    func titleEditHandler(with alertAction: UIAlertAction) -> ((UITextField) -> Swift.Void)? {
        let handler = {(textField: UITextField) in
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: .main) { (notification) in
                alertAction.isEnabled = self.isTitleValid(textField.text)
            }
            
            return
        }
        
        return handler
    }
    
    func showCreateNewProjectDialog() {
        // TODO: localize messages
        self.delegate?.showCreateNewProjectDialog(with: "Project", message: "Create new project", create: "Create", cancel: "Cancel", placeholder: "Create new project")
    }
    
    // MARK: - ProjectsInteractionDelegate methods
    
    func willChangeContent() {
        self.delegate?.willChangeContent()
    }
    
    func didChangeContent() {
        self.delegate?.didChangeContent()
    }
    
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.delegate?.changed(at: indexPath, for: type, newIndexPath: newIndexPath)
    }
}
