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
    @IBOutlet var currentEntryLabel: UILabel!
    @IBOutlet var lineChartView: LineChartView!
    var statistics: StatisticsGenerator?
    let dataController: DataController = DataController()
    var currentScore: Double = 0
    var currentLessons: Int16 = 0
    var entries: [LessonCapEntry]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lineChartView.delegate = self
        
        dataController.setupDataStack {
            let statistics = StatisticsGenerator(levels: [])
            self.statistics = statistics
        }
        
        self.refreshChart(nil)
        
        self.reloadChart()
    }
    
    @IBAction func refreshChart(_ sender: Any?) {
        self.statistics?.lessonCapScore(completion: { (score) in
            self.currentScore = score
            
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            if let currentScoreString = numberFormatter.string(from: NSNumber(value: score)) {
                self.lessonCapScoreLabel.text = "\(currentScoreString)"
            }
        })
        
        API.shared.summary { (summary) in
            if let lesson = summary.lessons.first {
                self.currentLessons = Int16(lesson.subject_ids.count)
                self.lessonNumberLabel.text = "\(lesson.subject_ids.count)"
            }
        }
        
        self.reloadChart()
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
            self.entries = entries
            let dataEntries: [ChartDataEntry] = entries.enumerated().map({ (arg) -> ChartDataEntry in
                
                let (offset, entry) = arg
                return ChartDataEntry(x: Double(offset), y: entry.score + Double(entry.lessonCount) * 3, data: entry)
            })
            
            let dateValueFormatter = DateValueFormatter()
            dateValueFormatter.entries = entries
            self.lineChartView.xAxis.valueFormatter = dateValueFormatter
            
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
        entry.lessonCount = currentLessons
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        self.reloadChart()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        if let xEntry = entries?[Int(entry.x)] {
            self.currentEntryLabel.text = "\(dateFormatter.string(from: xEntry.entryDate!)), \(xEntry.score), \(xEntry.lessonCount)"
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.currentEntryLabel.text = ""
    }
}

class DateValueFormatter: IAxisValueFormatter {
    var entries: [LessonCapEntry]? = nil
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let string = dateFormatter.string(from: (entries?[Int(value)].entryDate)!)
        return string
    }
}
