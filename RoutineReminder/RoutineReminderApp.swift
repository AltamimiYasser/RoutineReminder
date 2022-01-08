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
//    let noti = NotificationManager()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(dataController: dataController)
                    .onChange(of: scenePhase) { newScenePhase in
                        switch newScenePhase {

                        case .background:
                            print("🔥 going to background")
                        case .inactive:
                            dataController.save()
                           print("🔥 app inactive")
                        case .active:
                            dataController.reloadAllNotifications()
                            print("🔥 app is active")
                        @unknown default:
                            break
                        }
                    }
//                    .onAppear(perform: noti.deleteAllNotifications)
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
