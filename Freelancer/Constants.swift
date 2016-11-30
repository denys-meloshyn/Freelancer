//
//  Constants.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import Foundation

class Constants {
    static func defaultDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter
    }
    
    static func formatLoggedTime(dateComponents: DateComponents?) -> String {
        guard let hour = dateComponents?.hour, let minute = dateComponents?.minute, let second = dateComponents?.second else {
            return "00:00:00"
        }
        
        return String(format: "%02u:%02u:%02u", hour, minute, second)
    }
}
