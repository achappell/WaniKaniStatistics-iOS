//
//  LessonCapEntry+CoreDataProperties.swift
//  
//
//  Created by Amanda Chappell on 4/27/18.
//
//

import Foundation
import CoreData


extension LessonCapEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LessonCapEntry> {
        return NSFetchRequest<LessonCapEntry>(entityName: "LessonCapEntry")
    }

    @NSManaged public var score: Double
    @NSManaged public var entryDate: NSDate?

}
