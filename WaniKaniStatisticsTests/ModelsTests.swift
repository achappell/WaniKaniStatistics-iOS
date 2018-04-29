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
    
    func testLesson() {
        let lesson = Lesson(subject_ids: [1])
        XCTAssertEqual(lesson.subject_ids.first, 1)
    }
    
}
