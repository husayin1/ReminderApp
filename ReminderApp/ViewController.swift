//
//  ViewController.swift
//  ReminderApp
//
//  Created by husayn on 22/04/2024.
//

import UIKit

class ViewController: UIViewController {
    var pickedDate:Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func hotReminder(_ sender: Any) {
        schedulueNotification()
        print("Hot Reminder With Date Picker: \n ")
    }
    @IBAction func pickNotificationDate(_ sender: UIDatePicker) {
        pickedDate = sender.date
        print(pickedDate)
    }
    
    @IBAction func coldReminder(_ sender: Any) {
        scheduleNotificationWithAction()
        print("Cold Reminder With 30 Seconds")
    }
    func schedulueNotification() {
        //content
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Date has been picked"
        content.badge = NSNumber(value: 1)
        content.sound = UNNotificationSound.default
        //triger
        let targetDate = pickedDate.addingTimeInterval(10)
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                          from: targetDate),
                                                            repeats: false)
        //request
        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)
        
        //add request to notification
        UNUserNotificationCenter.current().add(request){error in
            if let error = error {
                print("Error Sceduling notification\n : \(error.localizedDescription)")
            }else{
                print("Notification scheduled successfully")
            }
        }
    }
    func scheduleNotificationWithAction() {
        //content
        let content = UNMutableNotificationContent()
        content.title = "Meeting"
        content.body = "Your meeting starts in 10 minutes!"
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: 2)
        //actions
        let action1 = UNNotificationAction(identifier: "snoozeAction", title: "Snooze", options: [])
        let action2 = UNNotificationAction(identifier: "cancelAction", title: "Cancel", options: [.destructive])
        //add action to category
        let category = UNNotificationCategory(identifier: "meetingCategory", actions: [action1, action2], intentIdentifiers: [], options: [])
        //set category
        UNUserNotificationCenter.current().setNotificationCategories([category])
        //category identifier
        content.categoryIdentifier = "meetingCategory"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)

        let request = UNNotificationRequest(identifier: "meetingNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification with actions scheduled successfully")
            }
        }
    }
}

