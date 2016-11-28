//
//  Project+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.11.16.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project");
    }

    @NSManaged public var title: String?
    @NSManaged public var registeredTimes: NSSet?

}

// MARK: Generated accessors for registeredTimes
extension Project {

    @objc(addRegisteredTimesObject:)
    @NSManaged public func addToRegisteredTimes(_ value: LoggedTime)

    @objc(removeRegisteredTimesObject:)
    @NSManaged public func removeFromRegisteredTimes(_ value: LoggedTime)

    @objc(addRegisteredTimes:)
    @NSManaged public func addToRegisteredTimes(_ values: NSSet)

    @objc(removeRegisteredTimes:)
    @NSManaged public func removeFromRegisteredTimes(_ values: NSSet)

}
