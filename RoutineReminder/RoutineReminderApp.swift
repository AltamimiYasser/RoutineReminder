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
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(dataController: dataController)
                    .onReceive(
                        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                        perform: save
                    )
            }
        }
    }

    private func save(_: Notification) {
        dataController.save()
    }
}
