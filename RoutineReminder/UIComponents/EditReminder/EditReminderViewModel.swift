//
//  EditReminderViewModel.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import Foundation

extension EditReminderView {
    class ViewModel: ObservableObject {
        private let dataController: DataController

        @Published var title: String = ""
        @Published var reminderType: Reminder.TypeOfReminder
        @Published var repeated: Bool = false
        @Published var oneTimeTime: Date = Date()
        @Published var hourlyTimeInterval: Int = 30.minutesToSeconds()
        @Published var dailyTimes: [Date] = []
        @Published var weeklyDays: [Int: [Date]] = [:]
        @Published var monthlyDays: [Date: [Date]] = [:]

        private var reminder: Reminder

        init(dataController: DataController, reminder: Reminder? = nil) {
            self.dataController = dataController
            self.reminder = reminder ?? Reminder(context: dataController.context)
            self.reminderType = reminder?.type ?? .oneTime(time: Date())
            assignReminderValues()
        }

        private func assignReminderValues() {
            switch reminderType {

            case .oneTime(time: let time):
                self.repeated = false
                self.oneTimeTime = time

            case .hourly(interval: let interval):
                self.repeated = true
                self.hourlyTimeInterval = interval

            case .daily(times: let times):
                self.repeated = true
                self.dailyTimes = times

            case .weekly(days: let days):
                self.repeated = true
                self.weeklyDays = days

            case .monthly(days: let days):
                self.repeated = true
                self.monthlyDays = days
            }
        }
    }

}
