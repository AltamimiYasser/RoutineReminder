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
            RemindersListView(dataController: dataController)
        }
    }
}
