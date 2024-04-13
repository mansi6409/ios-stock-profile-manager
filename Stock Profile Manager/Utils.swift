//
//  Utils.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/12/24.
//

import Foundation
struct Utils {
    static func relativeTimeString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: date, to: now)
        
        guard let hours = components.hour, let minutes = components.minute else {
            return "Just now"
        }
        
        var result = ""
        if hours > 0 {
            result += "\(hours) hr"
        }
        
        if minutes > 0 {
            if !result.isEmpty {
                result += ", "
            }
            result += "\(minutes) min"
        }
        
        if result.isEmpty {
            result = "Just now"
        }
        
        return result
    }
}
