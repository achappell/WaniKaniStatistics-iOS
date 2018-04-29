//
//  LevelProgression.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 1/30/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import Foundation

struct Container<T: Codable>: Codable {
    var data: [ContainerData<T>]
    var total_count: Int
}

struct ContainerData<T: Codable>: Codable {
    var data: T
}

struct UserContainer: Codable {
    var data: User
}

struct LevelProgression: Codable {
    var level: Int
    var started_at: String
    var passed_at: String?
    
    func startedAt() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter.date(from: started_at)
    }
}

struct User: Codable {
    var level: Int
}

struct Assignment: Codable {
    var created_at: String
    var level: Int
}

struct Summary: Codable {
    var lessons: [Lesson]
}

struct Lesson: Codable {
    var subject_ids: [Int]
}
