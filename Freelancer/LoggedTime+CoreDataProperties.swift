//
//  LoggedTime+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 30/11/2016.
//
//

import Foundation
import CoreData


extension LoggedTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggedTime> {
        return NSFetchRequest<LoggedTime>(entityName: "LoggedTime");
    }

    @NSManaged public var finish: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var start: NSDate?
    @NSManaged public var project: Project?

}
