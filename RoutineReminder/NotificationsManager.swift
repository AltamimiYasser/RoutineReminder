//
//  NotificationsManager.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import Foundation
import UserNotifications
import SwiftUI

final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    private init() {}

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

    private func createRequest(
        id: String,
        content: UNMutableNotificationContent,
        trigger: UNNotificationTrigger,
        completion: @escaping (Error?) -> Void
    ) {
        if content.title.isEmpty { content.title = "Routine Reminder"}
        if content.body.isEmpty { content.body = "Routine Reminder"}
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }

    private func createMultipleCalendarNotifications(
        title: String,
        message: String?,
        times: [Date],
        for day: Int? = nil,
        id: String,
        completion: @escaping (Error?) -> Void
    ) {
        for index in times.indices {
            var components = Calendar.current.dateComponents([.hour, .minute], from: times[index])
            var id = "\(id)\(index)"
            if let day = day {
                components.weekday = day
                id = "\(id)\(day)\(index)"
            }
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let content = createContent(title: title, message: message)

            createRequest(id: id, content: content, trigger: trigger, completion: completion)
        }
    }

    func createOneTimeReminder(
        title: String,
        message: String?,
        date: Date,
        id: String,
        completion: @escaping (Error?) -> Void
    ) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let content = createContent(title: title, message: message)
        createRequest(id: id, content: content, trigger: trigger, completion: completion)
    }

    func createHourlyReminder(
        title: String,
        message: String?,
        interval: Int,
        id: String,
        completion: @escaping (Error?) -> Void
    ) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: true)
        let content = createContent(title: title, message: message)
        createRequest(id: id, content: content, trigger: trigger, completion: completion)
    }

    func createDailyReminder(
        title: String,
        message: String?,
        times: [Date],
        id: String,
        completion: @escaping(Error?) -> Void
    ) {
        createMultipleCalendarNotifications(
            title: title,
            message: message,
            times: times,
            id: id,
            completion: completion
        )
    }

    func createWeeklyReminder(
        title: String,
        message: String?,
        days: [Int: [Date]],
        id: String,
        completion: @escaping(Error?) -> Void
    ) {
        for (day, times) in days {
            createMultipleCalendarNotifications(
                title: title,
                message: message,
                times: times,
                for: day,
                id: id,
                completion: completion
            )
        }
    }

    func deleteNotifications(withID identifiers: [String], type: Reminder.TypeOfReminderData) {
        switch type {
        case .daily(times: let times):
            for index in times.indices {
                let id = "\(identifiers.first!)\(index)"
                deleteNotification(withIDs: [id])
            }
        case .weekly(days: let days):
            for (day, times) in days {
                for index in times.indices {
                    let id = "\(identifiers.first!)\(day)\(index)"
                    deleteNotification(withIDs: [id])
                }
            }
        default:
            deleteNotification(withIDs: identifiers)
        }
    }

    private func deleteNotification(withIDs identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
