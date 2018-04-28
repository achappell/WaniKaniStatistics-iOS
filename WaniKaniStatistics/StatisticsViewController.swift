//
//  StatisticsViewController.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 1/30/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var averageLevelUpTime: UILabel!
    @IBOutlet var barChartView: BarChartView!
    var statistics: StatisticsGenerator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        barChartView.delegate = self
        
        API().levelProgressions { [weak self] (levels) in
            let statistics = StatisticsGenerator(levels: levels)
            self?.statistics = statistics
            
            let validLevels = levels.filter({ (data) -> Bool in
                data.abandoned_at == nil
            })
            
            let chartDataEntry: [BarChartDataEntry] = validLevels.map({ (level) -> BarChartDataEntry in
                return BarChartDataEntry(x: Double(level.level), y: statistics.levelUpTimeInDays(level))
            })
            let chartSet: BarChartDataSet = BarChartDataSet(values: chartDataEntry, label: "Levels")
            let data = BarChartData(dataSet: chartSet)
            data.barWidth = 0.9
            self?.barChartView.data = data
            
            let daysAndHours = statistics.averageLevelUpTime().daysAndHours()
            self?.averageLevelUpTime.text = "Average: \(daysAndHours.days) days \(daysAndHours.hours) hours"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
