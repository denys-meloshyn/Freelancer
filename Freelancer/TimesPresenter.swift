//
//  TimesPresenter.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol TimePresenterDelegate: ContentInteractionDelegate {
    func cancelEdit()
    func createCell(with title: String?, and detailText: String?) -> UITableViewCell?
    func showDeleteDialog(with title: String, message: String, cancelTitle: String, deleteTitle: String, indexPath: IndexPath)
    func createDeleteProjectRowAction(with title: String, and handler: @escaping (UITableViewRowAction, IndexPath) -> Swift.Void) -> UITableViewRowAction
}

class TimesPresenter: NSObject, UITableViewDelegate, UITableViewDataSource, ContentInteractionDelegate {
    let router = TimeRouter()
    let interaction = TimesInteraction()
    var currentProjectID: NSManagedObjectID?
    weak var delegate: TimePresenterDelegate?
    weak var viewController: UIViewController?

    func initialConfiguration() {
        self.router.viewController = self.viewController

        self.interaction.currentProjectID = self.currentProjectID
        self.interaction.initialConfiguration()
        self.interaction.delegate = self
    }

    // MARK: - UITableViewDataSource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.interaction.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interaction.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let time = self.interaction.time(for: indexPath)

        var spentTime = ""
        if let date = time?.spent()?.date {
            let formatter = DateFormatter()
            spentTime = formatter.string(from: date)
        }

        guard let cell = self.delegate?.createCell(with: time?.title, and: spentTime) else {
            return UITableViewCell()
        }

        return cell
    }

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let time = self.interaction.time(for: indexPath)
        self.router.presentTimeEditScreen(for: time?.objectID)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteHandler = { (action: UITableViewRowAction, indexPath: IndexPath) in
            self.delegate?.showDeleteDialog(with: "Delete", message: "Do you want to delete logged time?", cancelTitle: "Cancel", deleteTitle: "Delete", indexPath: indexPath)

            return
        }

        guard let deleteAction = self.delegate?.createDeleteProjectRowAction(with: "Delete", and: deleteHandler) else {
            return nil
        }
        
        return [deleteAction]
    }

    // MARK: - Public methods

    func confirmDeleteHandler(with indexPath: IndexPath) -> ((UIAlertAction) -> Swift.Void)? {
        guard let time = self.interaction.time(for: indexPath) else {
            return nil
        }

        let handler = { (alertAction: UIAlertAction) in
            self.interaction.delete(time)
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

    func createNewTime() {
        self.router.presentTimeEditScreen(for: self.currentProjectID)
    }

    // MARK: - TimePresenterDelegate methods

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
