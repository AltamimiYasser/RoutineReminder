//
//  HomeView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import SwiftUI

struct HomeView: View {
    private let dataController: DataController
    @StateObject private var notificationManager = NotificationManager.shared

    init(dataController: DataController) {
        self.dataController = dataController
    }

    var body: some View {
        Group {
            switch notificationManager.authorizationStatus {
            case .authorized:
                RemindersListView(dataController: dataController)
            case .denied:
                RemindersListView(dataController: dataController, showNotificationSheet: true)
                InfoOverlayView(
                    infoMessage: "Please Enable Notification Permission In Settings",
                    buttonTitle: "Settings",
                    systemImageName: "gear",
                    action: openSettings
                )
            default:
                InfoOverlayView(
                    infoMessage: "An error occurred. Please make sure to enable notifications in Settings",
                    buttonTitle: "Settings",
                    systemImageName: "gear",
                    action: openSettings
                )
            }
        }
        .onAppear(perform: notificationManager.reloadAuthorizationStatus)
        .onChange(of: notificationManager.authorizationStatus, perform: reactToAuthStatusChanges)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            notificationManager.reloadAuthorizationStatus()
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func reactToAuthStatusChanges(status: UNAuthorizationStatus?) {
        switch status {
        case .notDetermined:
            notificationManager.requestAuthorization()
        default:
            break
        }
    }

}
