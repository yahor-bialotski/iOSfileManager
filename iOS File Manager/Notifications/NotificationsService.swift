//
//  Notifications.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 4.07.22.
//

import UIKit
import UserNotifications

class NotificationsService: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func requestNotificationsPermisson() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        }
    }
    
    func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.body = "Hey, don't you want to create some folders? :D"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false) // shows notification in 10 mins after quit
        
        let request = UNNotificationRequest(identifier: "10 mins after quit",
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendAnotherLocalNotification() {
        let content = UNMutableNotificationContent()
        content.body = "We are missing you :("
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 10, minute: 00), repeats: true)
        
        let request = UNNotificationRequest(identifier: "every morning",
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

