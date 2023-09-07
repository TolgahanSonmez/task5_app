//
//  AlarmTabBarController.swift
//  Task5_app
//
//  Created by Tolgahan Sonmez on 1.09.2023.
//

import UIKit

class AlarmTabBarController: UITabBarController {
    
    var tabItem1  = UITabBarItem()
    var tabItem2  = UITabBarItem()
    var clockImage = UIImage(systemName: "clock")
    var alarmImage = UIImage(systemName: "alarm")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItem1 = self.tabBar.items![0]
        tabItem2 = self.tabBar.items![1]
        tabItem1.title = "Clock"
        tabItem2.title = "Alarm"
        tabItem1.image = clockImage
        tabItem2.image = alarmImage   
    }
}
