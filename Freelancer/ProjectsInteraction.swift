//
//  ProjectsInteraction.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol ContentInteractionDelegate: class {
    func didChangeContent()
    func willChangeContent()
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
}

protocol ProjectsInteractionDelegate: ContentInteractionDelegate {
}

class ProjectsInteraction: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: ProjectsInteractionDelegate?
    private var fetchedResultsController = ModelManager.projectsFetchedResultController(with: ModelManager.sharedInstance.managedObjectContext)
    
    func initialConfiguration() {
        do {
            try self.fetchedResultsController.performFetch()
            self.fetchedResultsController.delegate = self
        }
        catch {
            // TODO: error handling
        }
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
    
    //MARK: - Public methods
    
    func numberOfProjects() -> Int {
        guard let section = self.fetchedResultsController.sections?.first else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func createNewProject() -> Project {
        let project = Project(context: ModelManager.sharedInstance.managedObjectContext)
        
        return project
    }
    
    func saveProjectChanges() {
        ModelManager.saveContext(ModelManager.sharedInstance.managedObjectContext)
    }
    
    func project(for indexPath: IndexPath) -> Project {
        let project = self.fetchedResultsController.object(at: indexPath)
        
        return project
    }

    func delete(_ project: Project) {
        ModelManager.sharedInstance.managedObjectContext.delete(project)

        self.saveProjectChanges()
    }
}
