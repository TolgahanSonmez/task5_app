//
//  AddAlarmViewController.swift
//  Task5_app
//
//  Created by Tolgahan Sonmez on 1.09.2023.
//

import UIKit
import UserNotifications

protocol AddNewAlarmDelegate: AnyObject {
    func newAlarmAdded(with alarm: Alarm)
}

class AddAlarmViewController: UIViewController {
    
    //Delegation ile veri taşıma
    weak var delegate: AddNewAlarmDelegate?
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIPickerView!
    
    let hour = Array(00...23)
    let minute = Array(00...59)
    
    var selectedHour: Int = 0 // Kullanıcının seçtiği saat
    var selectedMinute: Int = 0 // Kullanıcının seçtiği dakika
    var selectedNotificationSound = ""
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Alarm"
        //Saat Güncelleme
        updateClock()
        datePicker.layer.cornerRadius = 8
        datePicker.isHidden = true
        datePicker.delegate = self
        datePicker.dataSource = self
        
        //timeLabel tıklama
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        timeLabel.addGestureRecognizer(tapGesture)
        timeLabel.isUserInteractionEnabled = true
        
        //NotificationPermission
        setupNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectSoundSegue" {
            let destVC = segue.destination as? SoundSelectionViewController
            destVC?.delegate = self
        }
    }
    
    @objc func labelTapped() {
        // Labela tıklandığında DatePicker'ı görüntüle
        showDatePicker()
    }
    
    func showDatePicker() {
        // DatePicker'ı görüntüle ve kullanıcıya saati seçme olanağı sağla
        datePicker.isHidden = false
    }
    
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Bildirim izni verildi.")
            } else {
                print("Bildirim izni reddedildi.")
            }
        }
    }
    
    @IBAction func saveAlarmButtonTapped(_ sender: UIBarButtonItem) {
        
        let currentDate = Date()
        let calendar = Calendar.current
        var alarmDate = calendar.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: currentDate)
        
        // Eğer seçilen zaman şu anki zamandan önceyse, alarmı bir sonraki güne ayarlayın
        if alarmDate! < currentDate {
            alarmDate = calendar.date(byAdding: .day, value: 1, to: alarmDate!)
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Alarm zamanı geldi!"
        if selectedNotificationSound.isEmpty {
            // selectedNotificationSound boşsa, varsayılan bildirim sesini kullan
            content.sound = UNNotificationSound.default
        } else {
            // selectedNotificationSound doluysa, kullanıcının seçtiği sesi kullan
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: selectedNotificationSound))
        }
        
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: alarmDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "alarmNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
            } else {
                print("Bildirim başarıyla eklendi.")
            }
        }
        
        //Alarm modeli
        let newAlarm = Alarm(hour: selectedHour, minute: selectedMinute)
        delegate?.newAlarmAdded(with: newAlarm)
        
        //Show Alert
        let alertController = UIAlertController(title: "Alarm Eklendi", message: "Alarm başarıyla eklendi.", preferredStyle: .alert)
        
        // Tamam düğmesi
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // UIAlertController'ı göster
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func selectSoundButtonTapped(_ sender: UIButton) {
        //Storyboard segue
    }
    
    func hideDatePicker() {
        datePicker.isHidden = true
    }
    
    func updateClock() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentTime = Date()
        let timeString = dateFormatter.string(from: currentTime)
        // Saat etiketini güncelleyin
        timeLabel.text = timeString
    }
    
}

extension AddAlarmViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? hour.count : minute.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let hour = hour[row] < 10 ? "0\(hour[row])" : "\(hour[row])"
            return hour
        } else {
            let minute = minute[row] < 10 ? "0\(minute[row])" : "\(minute[row])"
            return minute
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHour = hour[pickerView.selectedRow(inComponent: 0)]
        selectedMinute = minute[pickerView.selectedRow(inComponent: 1)]
        
        let formattedHour = String(format: "%02d", selectedHour)
        let formattedMinute = String(format: "%02d", selectedMinute)
        timeLabel.text = "\(formattedHour) : \(formattedMinute)"
        datePicker.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
}

extension AddAlarmViewController: SoundSelectionDelegate {
    func didSelectSound(_ soundName: String) {
        selectedNotificationSound = soundName
        print(selectedNotificationSound)
        print("delegate çalışıyor.....")
    }
}

