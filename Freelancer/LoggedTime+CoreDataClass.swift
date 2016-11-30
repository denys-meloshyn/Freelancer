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
        let units = Set<Calendar.Component>([.hour, .minute, .second])
        
        guard let start = self.start as? Date, let finish = self.finish as? Date else {
            return nil
        }
        
        return calendar.dateComponents(units, from: start, to: finish)
    }
}
