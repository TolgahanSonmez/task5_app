//
//  ViewController.swift
//  Task5_app
//
//  Created by Tolgahan Sonmez on 1.09.2023.
//

import UIKit

class ClockViewController: UIViewController {
    
    @IBOutlet weak var label_Date: UILabel!
    @IBOutlet weak var label_Clock: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func updateClock() {
        // Şu anki zamanı alın
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let currentTime = Date()
        let timeString = dateFormatter.string(from: currentTime)
        
        // Saat etiketini güncelleyin
        label_Clock.text = timeString
        
        // Tarih etiketini güncelleyin
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: currentTime)
        label_Date.text = dateString
    }
}

