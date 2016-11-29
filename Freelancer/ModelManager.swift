//
//  ModelManager.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 28.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import Foundation
import CoreData

class ModelManager {
    static let sharedInstance = ModelManager()
    
    private init() {
        
    }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Freelancer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext (_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    static func saveChildrenManagedObjectContext(_ childrenManagedObjectContext: NSManagedObjectContext) {
        guard let parentManagedObjectContext = childrenManagedObjectContext.parent else {
            return
        }

        childrenManagedObjectContext.perform { () -> Void in
            ModelManager.saveContext(childrenManagedObjectContext)

            childrenManagedObjectContext.parent?.perform({() -> Void in
               ModelManager.saveContext(parentManagedObjectContext)
            })
        }
    }

    // MARK: - Public methods

    var managedObjectContext:NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    static func createChildrenManagedObjectContext(from parentContext: NSManagedObjectContext?) -> NSManagedObjectContext {
        let childrenManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childrenManagedObjectContext.parent = parentContext

        return childrenManagedObjectContext
    }
    
    static func projectsFetchedResultController(with managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<Project> {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.fetchBatchSize = 30
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

    static func timeFetchedResultController(for project: NSManagedObjectID, with managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<LoggedTime> {
        let fetchRequest: NSFetchRequest<LoggedTime> = LoggedTime.fetchRequest()
        fetchRequest.fetchBatchSize = 30

        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
}
