//
//  LessenCapViewController.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 4/27/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import UIKit
import Charts
import CoreData

class LessonCapViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var lessonCapScoreLabel: UILabel!
    @IBOutlet var lessonNumberLabel: UILabel!
    @IBOutlet var lineChartView: LineChartView!
    var statistics: StatisticsGenerator?
    let dataController: DataController = DataController()
    var currentScore: Double = 0
    var currentLessons: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lineChartView.delegate = self
        
        dataController.setupDataStack {
            let statistics = StatisticsGenerator(levels: [])
            self.statistics = statistics
        }
        
        self.statistics?.lessonCapScore(completion: { (score) in
            self.currentScore = score
            
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            if let currentScoreString = numberFormatter.string(from: NSNumber(value: score)) {
                self.lessonCapScoreLabel.text = "\(currentScoreString)"
            }
        })
        
        self.reloadChart()
        
        API.shared.summary { (summary) in
            if let lesson = summary.lessons.first {
                self.currentLessons = lesson.subject_ids.count
                self.lessonNumberLabel.text = "\(lesson.subject_ids.count)"
            }
        }
    }
    
    func reloadChart() {
        do {
            var entries = try (dataController.persistentContainer.viewContext.fetch(LessonCapEntry.fetchRequest()) as! [LessonCapEntry])
            entries.sort { (left, right) -> Bool in
                if let leftDate = left.entryDate, let rightDate = right.entryDate {
                    return leftDate.timeIntervalSince(rightDate) < 0
                }
                return false
            }
            let dataEntries: [ChartDataEntry] = entries.enumerated().map({ (arg) -> ChartDataEntry in
                
                let (offset, entry) = arg
                return ChartDataEntry(x: Double(offset), y: entry.score + Double(self.currentLessons) * 3)
            })
            let dataSet = LineChartDataSet(entries: dataEntries, label: "Score")
            self.lineChartView.data = LineChartData(dataSet: dataSet)
        } catch {
            
        }
    }
    
    @IBAction func recordStats(_ sender: Any) {
        let context = self.dataController.persistentContainer.viewContext
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "LessonCapEntry", into: context) as! LessonCapEntry
        entry.score = currentScore
        entry.entryDate = Date()
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        self.reloadChart()
    }
}
