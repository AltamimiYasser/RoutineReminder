//
//  EditReminderViewModel.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import Foundation
import SwiftUI

extension EditReminderView {
    class ViewModel: ObservableObject {

        private let dataController: DataController
        @Published var reminder: Reminder?
        @Published var title = ""
        @Published var message  = ""

        @Published private var reminderTypeData: Reminder.TypeOfReminderData = .oneTime(time: Date())
        @Published var reminderType: Reminder.TypeOfReminder = .oneTime

        @Published var oneTimeTime = Date()
        @Published var hourlyDuration = TimeInterval(30.minutesToSeconds())
        @Published var dailyTimes: [Date] = []
        @Published var weekDays: [WeeklyReminder] = []

        var isEditing = false

        var footerDescription: LocalizedStringKey {
            switch reminderType {
            case .oneTime:
                return ""
            case .hourly:
               return "You will be reminded based on the specified duration"
            case .daily:
                return "You will be reminded daily on the times you add here"
            case .weekly:
               return "Add the days of the week here. You can have multiple reminders for a chosen weekday"
            }
        }

        var editButtonEnabled: Bool {
            if reminderType == .daily && !dailyTimes.isEmpty { return true }
            if reminderType == .weekly && !weekDays.isEmpty { return true }
            return false
        }

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

        private func assignReminderValues() {
            self.title = reminder?.title ?? ""
            self.message = reminder?.message ?? ""

            switch reminderTypeData {
            case .oneTime(time: let time):
                self.oneTimeTime = time

            case .hourly(interval: let interval):
                self.hourlyDuration = TimeInterval(interval)

            case .daily(times: let times):
                self.dailyTimes = times

            case .weekly(days: let days):
                self.weekDays = days.map {
                    WeeklyReminder(
                        dayOfTheWeekInt: $0.key,
                        dates: $0.value
                    )
                }
            }
        }

        // MARK: User Intent(s)
        func createWeekDay() {
            weekDays.append(WeeklyReminder(dayOfTheWeekInt: 1, dates: []))
        }

        func save() {
            switch reminderType {
            case .oneTime:
                dataController.createOrUpdateOneTimeReminder(
                    title: title,
                    time: oneTimeTime, message: message.isEmpty ? nil : message,
                    reminder: isEditing ? reminder : nil
                )
            case .hourly:
                print("🔥 interval is \(hourlyDuration)")
                dataController.createOrUpdateHourlyReminder(
                    title: title,
                    message: message.isEmpty ? nil : message,
                    interval: Int(hourlyDuration),
                    reminder: isEditing ? reminder : nil
                )
            case .daily:
                dataController.createOrUpdateDailyReminder(
                    title: title,
                    message: message.isEmpty ? nil : message,
                    times: dailyTimes,
                    reminder: isEditing ? reminder : nil
                )

            case .weekly:
                dataController.createOrUpdateWeeklyReminder(
                    title: title,
                    message: message.isEmpty ? nil : message,
                    daysAndTimes: weekDays.reduce([Int: [Date]]()) { (dict, weekday) -> [Int: [Date]] in
                        var dict = dict
                        dict[weekday.dayOfTheWeekInt] = weekday.dates
                        return dict
                    },
                    reminder: isEditing ? reminder : nil
                )
            }
        }

        func deleteTimeFromDailyTimes(at offsets: IndexSet) {
            dailyTimes.remove(atOffsets: offsets)
        }
    }

    struct WeeklyReminder: Equatable {
        var dayOfTheWeekStr: LocalizedStringKey { Reminder.getWeekDayStr(for: dayOfTheWeekInt).full }
        var dayOfTheWeekInt: Int
        var dates: [Date]
        var times: [LocalizedStringKey] { dates.map({ $0.getTimeAndDate().time }) }
    }
}
