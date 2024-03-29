//
//  RoutineReminderApp.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import SwiftUI

@main
struct RoutineReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    private let dataController = DataController()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(dataController: dataController)
                    .onChange(of: scenePhase) { newScenePhase in
                        switch newScenePhase {
                        case .inactive:
                            dataController.save()
                        case .active:
                            dataController.reloadAllNotifications()
                        case .background:
                            break
                        @unknown default:
                            break
                        }
                    }
            }
        }
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
