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
    
    func scoreMath(count: Int, weight: Double) -> Double {
        return Double(round(100*((Double(count)*weight)/2))/100)
    }
    
    func lessonCapScore(completion:((Double) -> Void)?) {
        var score: Double = 0.0
        API().assignments(level: 1) { (assignment) in
            score += self.scoreMath(count: assignment.total_count, weight: 6)
            
            API().assignments(level: 2) { (assignment) in
                score += self.scoreMath(count: assignment.total_count, weight: 3)
                
                API().assignments(level: 3) { (assignment) in
                    score += self.scoreMath(count: assignment.total_count, weight: 1.04)
                    
                    API().assignments(level: 4) { (assignment) in
                        score += self.scoreMath(count: assignment.total_count, weight: 0.51)
                        
                        API().assignments(level: 5) { (assignment) in
                            score += self.scoreMath(count: assignment.total_count, weight: 0.14)
                            
                            API().assignments(level: 6) { (assignment) in
                                score += self.scoreMath(count: assignment.total_count, weight: 0.07)
                                
                                API().assignments(level: 7) { (assignment) in
                                    score += self.scoreMath(count: assignment.total_count, weight: 0.03)
                                    
                                    API().assignments(level: 8) { (assignment) in
                                        score += self.scoreMath(count: assignment.total_count, weight: 0.01)
                                        
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
