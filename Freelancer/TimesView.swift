//
//  TimesView.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimesView: NSObject, TimePresenterDelegate {
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private weak var viewController: UIViewController?

    let presenter = TimesPresenter()
    var currentProjectID: NSManagedObjectID?
    private let cellIdentifier = "TimeTableViewCell"

    func initialConfiguration() {
        self.presenter.delegate = self
        self.presenter.currentProjectID = self.currentProjectID
        self.presenter.viewController = self.viewController
        self.presenter.initialConfiguration()

        self.configureUserInterface()
    }

    // MARK: - Private methods

    private func configureUserInterface() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self.presenter, action: #selector(TimesPresenter.createNewTime))
        self.viewController?.navigationItem.rightBarButtonItem = addBarButtonItem

        self.tableView?.dataSource = self.presenter
        self.tableView?.delegate = self.presenter
    }

    // MARK: - TimePresenterDelegate methods

    func createDeleteProjectRowAction(with title: String, and handler: @escaping (UITableViewRowAction, IndexPath) -> Void) -> UITableViewRowAction {
        let deleteAction = UITableViewRowAction(style: .destructive, title: title, handler: handler)

        return deleteAction
    }

    func cancelEdit() {
        self.tableView?.isEditing = false
    }

    func showDeleteDialog(with title: String, message: String, cancelTitle: String, deleteTitle: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: deleteTitle, style: .destructive, handler: self.presenter.confirmDeleteHandler(with: indexPath))
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: self.presenter.cancelDeleteHandler())

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        self.viewController?.present(alertController, animated: true, completion: nil)
    }

    func createCell(with title: String?, and detailText: String?) -> UITableViewCell? {
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
