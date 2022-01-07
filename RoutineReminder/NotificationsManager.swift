//
//  NotificationsManager.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import Foundation
import UserNotifications

final class NotificationManager: ObservableObject {

    @Published private(set) var authorizationStatus: UNAuthorizationStatus?

    // updates the published authorizations status
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }

    private func createContent(title: String, message: String?) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        if let message = message {
            content.body = message
        }
        return content
    }

    func createOneTimeReminder(
        title: String,
        date: Date,
        message: String?,
        id: String,
        completion: @escaping (Error?) -> Void
    ) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let content = createContent(title: title, message: message)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
//    func createLocalNotification(title: String, hour: Int, minute: Int, completion: @escaping (Error?) -> Void) {
//        var dateComponents = DateComponents()
//        dateComponents.hour = hour
//        dateComponents.minute = minute
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//        let notificationContent = UNMutableNotificationContent()
//        notificationContent.title = title
//        notificationContent.sound = .default
//        notificationContent.body = "some message"
//
//        let request = UNNotificationRequest(
//            identifier: UUID().uuidString,
//            content: notificationContent,
//            trigger: trigger
//        )
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
//    }

    // delete a notification with the specified id
//    func deleteLocalNotifications(withID identifiers: [String]) {
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
//    }
}
