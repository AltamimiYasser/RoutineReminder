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
            if !isEditing {
                switch reminderType {

                case .oneTime:
                    dataController.createOneTimeReminder(title: title, time: oneTimeTime)
                case .hourly:
                    dataController.createHourlyReminder(title: title, interval: hourlyTimeInterval)
                case .daily:
                    dataController.createDailyReminder(title: title, times: dailyTimes)
                case .weekly:
                    dataController.createWeeklyReminder(title: title, daysAndTimes: weeklyDays)
                case .monthly:
                    dataController.createMonthlyReminder(title: title, times: monthlyDays)
                }
            } else {
                
            }
            dataController.save()
        }
    }

}
