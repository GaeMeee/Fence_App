//
//  UNUserNotification+Ext.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/31/23.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(title: String, body: String, id: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: DateComponents(second: 5), to: .now)
        let components = calendar.dateComponents([.hour, .minute, .second], from: newDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        self.add(request, withCompletionHandler: nil)
    }
}
