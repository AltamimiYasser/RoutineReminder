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
        @Published private var reminderTypeData: Reminder.TypeOfReminderData = .oneTime(time: Date())
        @Published var reminderType: Reminder.TypeOfReminder = .oneTime
        @Published var repeated = false
        @Published var oneTimeTime = Date()
        @Published private var hourlyTimeInterval = 30.minutesToSeconds()
        @Published var dailyTimes: [Date] = []
        @Published var weeklyDays: [Int: [Date]] = [:]
        @Published var monthlyDays: [Date: [Date]] = [:]

        @Published var timeIntervalHoursPicker = 0
        @Published var timeIntervalMinutesPicker = 30
        var minutesPickersRangeMin: Int {
            if timeIntervalHoursPicker == 0 { return 1 }
            return 0
        }

        private var isEditing = false

        @Published var reminder: Reminder?

        init(dataController: DataController, reminder: Reminder? = nil) {
            self.dataController = dataController
            if let reminder = reminder {
                isEditing = true
                self.reminder = reminder
                self.reminderType = reminder.type
                self.reminderTypeData = reminder.typeData
            }
            assignReminderValues()

        }

        func repeatedChanged(to newValue: Bool) {
            if newValue == false {
                reminderType = .oneTime
            } else {
                reminderType = .hourly
            }
        }

        private func assignReminderValues() {
            self.title = reminder?.title ?? ""
            switch reminderTypeData {

            case .oneTime(time: let time):
                self.repeated = false
                self.oneTimeTime = time

            case .hourly(interval: let interval):
                self.repeated = true
                self.hourlyTimeInterval = interval
                let (hours, minutes) = interval.secondsToHoursAndMinutes()
                self.timeIntervalHoursPicker = hours
                self.timeIntervalMinutesPicker = minutes

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

        func hoursIntervalChanged(_ newValue: Int) {
            self.hourlyTimeInterval += newValue.hoursToSeconds()
        }

        func minutesIntervalChanged(_ newValue: Int) {
            if timeIntervalHoursPicker == 0 { timeIntervalMinutesPicker = 1}
            self.hourlyTimeInterval += newValue.minutesToSeconds()
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
