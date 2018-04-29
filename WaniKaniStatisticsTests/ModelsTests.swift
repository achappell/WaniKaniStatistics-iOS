//
//  ModelsTests.swift
//  WaniKaniStatisticsTests
//
//  Created by Amanda Chappell on 4/29/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import XCTest
@testable import WaniKaniStatistics

class ModelsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLessonInit() {
        let lesson = Lesson(subject_ids: [1])
        XCTAssertEqual(lesson.subject_ids.first, 1)
    }
    
    func testLevelProgressionInit() {
        let levelProgression = LevelProgression(level: 1, started_at: "2018-04-29T16:00:00.000000Z", passed_at: "2018-04-29T16:00:00.000000Z", abandoned_at: "2018-04-29T16:00:00.000000Z")
        XCTAssertEqual(levelProgression.level, 1)
        XCTAssertEqual(levelProgression.started_at, "2018-04-29T16:00:00.000000Z")
        XCTAssertEqual(levelProgression.passed_at, "2018-04-29T16:00:00.000000Z")
        XCTAssertEqual(levelProgression.abandoned_at, "2018-04-29T16:00:00.000000Z")
    }
    
    func testLevelProgressionStartedAt() {
        let levelProgression = LevelProgression(level: 1, started_at: "2018-04-29T16:00:00.000000Z", passed_at: "2018-04-29T16:00:00.000000Z", abandoned_at: "2018-04-29T16:00:00.000000Z")
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        
        XCTAssertEqual(levelProgression.startedAt(),formatter.date(from: "2018-04-29T16:00:00.000000Z"))
    }
    
}
