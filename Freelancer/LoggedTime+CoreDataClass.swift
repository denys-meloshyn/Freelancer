//
//  LoggedTime+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 28.11.16.
//
//

import Foundation
import CoreData

@objc(LoggedTime)
public class LoggedTime: NSManagedObject {
    func spent() -> DateComponents? {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .second])
        
        guard let fromDate = self.start as? Date, let toDate = self.finish as? Date else {
            return nil
        }
        
        return calendar.dateComponents(units, from: fromDate, to: toDate)
    }
}
