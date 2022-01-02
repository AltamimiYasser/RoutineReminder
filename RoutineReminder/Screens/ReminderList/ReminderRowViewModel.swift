//
//  ReminderRowViewModel.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import Foundation

extension ReminderRowView {
    class ViewModel: ObservableObject {
        @Published var reminder: Reminder
        @Published var isEnabled: Bool

        private var dataController: DataController

        init(dataController: DataController, reminder: Reminder) {
            self.dataController = dataController
            self.reminder = reminder
            self.isEnabled = reminder.isEnabled
        }

        func save() {
            reminder.isEnabled = isEnabled
            dataController.save()
        }
    }
}
