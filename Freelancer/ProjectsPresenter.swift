//
//  ProjectsPresenter.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol ProjectsPresenterDelegate: class {
    func cancelEdit()
    func showCreateNewProjectDialog(with title:String, message messageText: String, create createTitle: String, cancel cancelTitle: String)
}

class ProjectsPresenter: NSObject, UITableViewDelegate, UITableViewDataSource {
    let interaction = ProjectsInteraction()
    weak var delegate: ProjectsPresenterDelegate?
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interaction.numberOfProjects()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //    var cell: UITableViewCell?
        //
        //    guard let cell = cell else {
        //        return UITableViewCell()
        //    }
        //
        //    return cell
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        return nil
    }
    
    // MARK: - Private methods
    
    private func isTitleValid(_ title: String?) -> Bool {
        let trimmedTitle = self.removeWhiteSpacesIn(eventTitle: title)
        
        if let text = trimmedTitle, text.characters.count == 0 {
            return false
        }
        
        return true
    }
    
    private func removeWhiteSpacesIn(eventTitle title: String?) -> String? {
        let trimmedTitle = title?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        return trimmedTitle
    }
    
    // MARK: - Public methods
    
    func createHandler(for alertController: UIAlertController) -> ((UIAlertAction) -> Void)? {
        let handler = {(alertAction: UIAlertAction) in
            guard let titleTextField = alertController.textFields?.first as UITextField? else {
                return
            }
            
            titleTextField.text = titleTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            
            self.delegate?.cancelEdit()
            if !self.isTitleValid(titleTextField.text) {
                return
            }
            
            let newProject = self.interaction.createNewProject()
            newProject.title = titleTextField.text
            self.interaction.saveProjectChanges()
            
            return
        }
        
        return handler
    }
    
    func showCreateNewProjectDialog() {
        self.delegate?.showCreateNewProjectDialog(with: "Project", message: "Create new project", create: "Create", cancel: "Cancel")
    }
}
