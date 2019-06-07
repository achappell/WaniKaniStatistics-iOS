//
//  StatisticsGenerator.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 2/4/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import Foundation

struct StatisticsGenerator {
    
    var levels: [LevelProgression]
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    init(levels: [LevelProgression]) {
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
    
    func levelUpTimeInDays(_ forLevel: LevelProgression) -> Double {
        if let startDate = forLevel.startedAt() {
            let endDate = dateFormatter.date(from: forLevel.passed_at ?? "") ?? Date()
            let levelUpTime = endDate.timeIntervalSince(startDate)
            return levelUpTime/60.0/60.0/24.0
        }
        return 0
    }
    
    func lessonCapScore(completion:((Double) -> Void)?) {
        var score: Double = 0.0
        API().assignments(level: 1) { (assignment) in
            score = score +  ((Double(assignment.total_count) * 6) / 2).rounded(.toNearestOrAwayFromZero)
            
            API().assignments(level: 2) { (assignment) in
                score = score + (Double(assignment.total_count) * 3) / 2
                
                API().assignments(level: 3) { (assignment) in
                    score = score + (Double(assignment.total_count) * 1.04) / 2
                    
                    API().assignments(level: 4) { (assignment) in
                        score = score + (Double(assignment.total_count) * 0.51) / 2
                        
                        API().assignments(level: 5) { (assignment) in
                            score = score + (Double(assignment.total_count) * 0.14) / 2
                            
                            API().assignments(level: 6) { (assignment) in
                                score = score + (Double(assignment.total_count) * 0.07) / 2
                                
                                API().assignments(level: 7) { (assignment) in
                                    score = score + (Double(assignment.total_count) * 0.03) / 2
                                    
                                    API().assignments(level: 8) { (assignment) in
                                        score = score + (Double(assignment.total_count) * 0.01) / 2
                                        
                                        completion?(score)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
