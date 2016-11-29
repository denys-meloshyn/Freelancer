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
}
