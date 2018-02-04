//
//  Date+Extensions.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 2/4/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import UIKit

extension Date {
 
    func daysAndHoursSinceNow() -> (days: Int, hours: Int) {
        let timeSinceStartedLevelInHours = abs(self.timeIntervalSinceNow)
        return timeSinceStartedLevelInHours.daysAndHours()
    }
}

extension TimeInterval {
    func daysAndHours() -> (days: Int, hours: Int) {
        let days = Int(floor(self / 60.0 / 60.0 / 24))
        let hours = Int(self - Double(days) * 24.0 * 60.0 * 60.0) / 60 / 60
        
        return (days, hours)
    }
}
