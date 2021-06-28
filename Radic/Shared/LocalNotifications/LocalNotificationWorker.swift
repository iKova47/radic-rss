//
//  LocalNotificationWorker.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import UserNotifications

final class LocalNotificationWorker {

    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { authorised, error in
            guard !authorised else { return }

            Log.error("The user has declined the local notifications", error: error)
        }
    }

    static func sendNotification(title: String, message: String, body: String? = nil) {

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message

        if let body = body {
            content.body = body
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
