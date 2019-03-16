//
//  DateExtension.swift
//  CodeFoo9
//
//  Created by hor kimleng on 3/13/19.
//  Copyright © 2019 hor kimleng. All rights reserved.
//

import UIKit

extension Date {
    func durationAgo() -> String {
        let seconds = Int(Date().timeIntervalSince(self))
        let minutes = 60
        let hours = 60 * minutes
        let day = 24 * hours
        let week = 7 * day
        
        if seconds < minutes {
            return "\(seconds) seconds ago"
        } else if seconds < hours {
            return "\(seconds / minutes) minutes ago"
        } else if seconds < day {
            return "\(seconds / hours) hours ago"
        } else if seconds < week {
            return "\(seconds / day) days ago"
        }
        
        return "\(seconds / week) weeks ago"
    }
}

extension String {
    func formatStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: self)!
        return date
    }
}
