//
//  TimesInteraction.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimesInteraction: NSObject, NSFetchedResultsControllerDelegate {
    private var currentProject: Project?
    private let managedObjectContext = ModelManager.sharedInstance.managedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<LoggedTime>?

    weak var delegate: ContentInteractionDelegate?
    var currentProjectID: NSManagedObjectID? {
        didSet {
            guard let currentProjectID = self.currentProjectID else {
                return
            }

            self.currentProject = self.managedObjectContext.object(with: currentProjectID) as? Project
            self.fetchedResultsController = ModelManager.timeFetchedResultController(for: currentProjectID, with: self.managedObjectContext)
            self.fetchedResultsController?.delegate = self

            do {
                try self.fetchedResultsController?.performFetch()
            }
            catch {
                 // TODO: error handling
            }
        }
    }

    func initialConfiguration() {

    }

    // MARK: - NSFetchedResultsControllerDelegate methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.willChangeContent()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.didChangeContent()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.delegate?.changed(at: indexPath, for: type, newIndexPath: newIndexPath)
    }

    // MARK: - Public methods

    func numberOfSections() -> Int {
        guard let sections = self.fetchedResultsController?.sections else {
            return 0
        }

        return sections.count
    }

    func numberOfItems(in section: Int) -> Int {
        guard let sections = self.fetchedResultsController?.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }

    func time(for indexPath: IndexPath) -> LoggedTime? {
        let time = self.fetchedResultsController?.object(at: indexPath)

        return time
    }

    func delete(_ time: LoggedTime) {
        ModelManager.sharedInstance.managedObjectContext.delete(time)

        self.saveTimeChanges()
    }

    func saveTimeChanges() {
        ModelManager.saveContext(self.managedObjectContext)
    }
}
