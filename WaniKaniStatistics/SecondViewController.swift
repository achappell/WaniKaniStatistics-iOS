//
//  SecondViewController.swift
//  WaniKaniStatistics
//
//  Created by Amanda Chappell on 1/30/18.
//  Copyright © 2018 Amanda Chappell. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var timeOnLevelLabel: UILabel!
    @IBOutlet var levelUpInLabel: UILabel!
    @IBOutlet var averageLevelUpLabel: UILabel!
    
    var user: User?
    var statistics: StatisticsGenerator = StatisticsGenerator(levels: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        API.shared.user { [weak self] (userData) in
            self?.user = userData
            
            self?.levelLabel.text = "\(userData.level)"
            
            API.shared.levelProgressions(completion: { [weak self] (levelProgressions) in
                
                self?.statistics.levels = levelProgressions
                
                let currentLevelEntries = levelProgressions.filter({ (data) -> Bool in
                    data.level == userData.level && data.abandoned_at == nil
                })
                
                let level = currentLevelEntries.sorted { (first, second) -> Bool in
                    first.startedAt()!.compare(second.startedAt()!) == .orderedDescending
                }.first
                
                self?.setStatLabels(level)
            })
        }
    }
    
    func setStatLabels(_ levelProgression: LevelProgression?) {
        if let level = levelProgression {
            let time = level.startedAt()?.daysAndHoursSinceNow() ?? (days: 0, hours: 0)
            
            self.timeOnLevelLabel.text = "\(time.days) days \(time.hours) hours"
            
            let averageLevelUpDaysAndHours = self.statistics.averageLevelUpTime().daysAndHours()
            self.averageLevelUpLabel.text = "\(averageLevelUpDaysAndHours.days) days \(averageLevelUpDaysAndHours.hours) hours"
            
            if averageLevelUpDaysAndHours.hours > time.hours {
                self.levelUpInLabel.text = "\(averageLevelUpDaysAndHours.days - time.days) days \(averageLevelUpDaysAndHours.hours - time.hours) hours"
            } else {
                self.levelUpInLabel.text = "\(averageLevelUpDaysAndHours.days - time.days - 1) days \(averageLevelUpDaysAndHours.hours + 24 - time.hours) hours"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

