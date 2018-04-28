//
//  DataController.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 4/27/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    var persistentContainer: NSPersistentContainer
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Model")
    }
    
    func setupDataStack(completionClosure: @escaping () -> ()) {
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
}
