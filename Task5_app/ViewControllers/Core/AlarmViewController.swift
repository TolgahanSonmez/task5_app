//
//  AlarmViewController.swift
//  Task5_app
//
//  Created by Tolgahan Sonmez on 1.09.2023.
//

import UIKit

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var label_subtitleNoAlarm: UILabel!
    @IBOutlet weak var label_NoAlarm: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var alarms: [Alarm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateNoAlarmsMessage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAlarmSegue" {
            let destVC = segue.destination as? AddAlarmViewController
            destVC?.delegate = self
        }
    }
    
    func updateNoAlarmsMessage() {
        if alarms.isEmpty {
            label_NoAlarm.isHidden = false
            label_subtitleNoAlarm.isHidden = false
            tableView.isHidden = true
        } else {
            label_NoAlarm.isHidden = true
            label_subtitleNoAlarm.isHidden = true
            tableView.isHidden = false
        }
    }
    
    @IBAction func addAlarmButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddAlarmSegue", sender: self)
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TableView hücresini yapılandırma ve alarm bilgilerini gösterme işlemleri burada yapılabilir
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmTableViewCell
        let alarm = alarms[indexPath.row]
        let hourString: String
        let minuteString: String
        
        if alarm.hour < 10 {
            hourString = "0\(alarm.hour)"
        } else {
            hourString = "\(alarm.hour)"
        }
        
        if alarm.minute < 10 {
            minuteString = "0\(alarm.minute)"
        } else {
            minuteString = "\(alarm.minute)"
        }
        //cell.textLabel?.text = "\(hourString):\(minuteString)"
        //cell.textLabel?.text = "\(alarm.hour):\(alarm.minute)"
        cell.label_alarmTime.text = "\(hourString) : \(minuteString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension AlarmViewController: AddNewAlarmDelegate {
    func newAlarmAdded(with alarm: Alarm) {
        alarms.append(alarm)
        tableView.reloadData()
        updateNoAlarmsMessage()
    }
}
