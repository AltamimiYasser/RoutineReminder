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

    // I will keep this as an example but commented out and I will create separate function for each type of reminder
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
