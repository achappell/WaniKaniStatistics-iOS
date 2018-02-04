//
//  StatisticsGenerator.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 2/4/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import Foundation

struct StatisticsGenerator {
    
    var levels: [LevelProgressionData]
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    init(levels: [LevelProgressionData]) {
        self.levels = levels
    }
    
    func averageLevelUpTime() -> Double {
        let totalTime = levels.reduce((0, 0)) { (arg0, level) -> (Double, Int) in
            
            if let endDateString = level.passed_at, let endDate = dateFormatter.date(from: endDateString), let startDate = level.startedAt() {
                let levelUpTime = endDate.timeIntervalSince(startDate)
                return (arg0.0 + (levelUpTime), arg0.1 + 1)
            }
            return arg0
        }
        
        return totalTime.0 / Double(totalTime.1)
    }
    
    func levelUpTimeInDays(_ forLevel: LevelProgressionData) -> Double {
        if let startDate = forLevel.startedAt() {
            let endDate = dateFormatter.date(from: forLevel.passed_at ?? "") ?? Date()
            let levelUpTime = endDate.timeIntervalSince(startDate)
            return levelUpTime/60.0/60.0/24.0
        }
        return 0
    }
}
