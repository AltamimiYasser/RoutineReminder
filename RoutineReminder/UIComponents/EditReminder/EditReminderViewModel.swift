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

        @Published var title = ""
        @Published var reminderType: Reminder.TypeOfReminder = .oneTime(time: Date())
        @Published var repeated = false
        @Published var oneTimeTime: Date = Date()
        @Published var hourlyTimeInterval: Int = 30.minutesToSeconds()
        @Published var dailyTimes: [Date] = []
        @Published var weeklyDays: [Int: [Date]] = [:]
        @Published var monthlyDays: [Date: [Date]] = [:]

        private var isEditing = false

        @Published var reminder: Reminder

        init(dataController: DataController, reminder: Reminder? = nil) {
            self.dataController = dataController
            if reminder != nil {
                isEditing = true
            }
            self.reminder = reminder ?? Reminder(context: dataController.context)
            self.reminderType = reminder?.type ?? .oneTime(time: Date())
            assignReminderValues()
        }

        private func assignReminderValues() {
            self.title = reminder.title ?? ""
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

        func save() {
            switch reminderType {

            case .oneTime:
                dataController.createOrUpdateOneTimeReminder(
                    title: title, time: oneTimeTime, reminder: isEditing ? reminder : nil
                )
            case .hourly:
                dataController.createOrUpdateHourlyReminder(
                    title: title, interval: hourlyTimeInterval, reminder: isEditing ? reminder : nil
                )
            case .daily:
                dataController.createOrUpdateDailyReminder(
                    title: title, times: dailyTimes, reminder: isEditing ? reminder : nil)

            case .weekly:
                dataController.createOrUpdateWeeklyReminder(
                    title: title, daysAndTimes: weeklyDays, reminder: isEditing ? reminder : nil
                )
            case .monthly:
                dataController.createOrUpdateMonthlyReminder(
                    title: title, times: monthlyDays, reminder: isEditing ? reminder : nil
                )
            }

        }
    }

}
