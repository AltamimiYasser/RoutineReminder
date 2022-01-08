//
//  RoutineReminderApp.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import SwiftUI

@main
struct RoutineReminderApp: App {
    private let dataController = DataController()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    let noti = NotificationManager()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(dataController: dataController)
                    .onReceive(
                        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                        perform: save
                    )
//                    .onAppear(perform: noti.deleteAllNotifications)
            }
        }
    }

    private func save(_: Notification) {
        dataController.save()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Notification received with identifier \(notification.request.identifier)")
        completionHandler([.banner, .sound])
    }
}
