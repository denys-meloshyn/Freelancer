//
//  LoggedTime+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.11.16.
//
//

import Foundation
import CoreData


extension LoggedTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggedTime> {
        return NSFetchRequest<LoggedTime>(entityName: "LoggedTime");
    }

    @NSManaged public var spent: NSDate?
    @NSManaged public var start: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var project: Project?

}
