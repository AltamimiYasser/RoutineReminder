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
        @Published var reminder: Reminder?
        @Published var title = ""

        @Published private var reminderTypeData: Reminder.TypeOfReminderData = .oneTime(time: Date())
        @Published var reminderType: Reminder.TypeOfReminder = .oneTime

        @Published var oneTimeTime = Date()

//        @Published var hourlyIntervalTime: DurationPickerView.Time = .init(hour: 0, minute: 30)
        @Published var hourlyDuration = TimeInterval(30.minutesToSeconds())
//        @Published var timeIntervalHoursPicker = 0
//        @Published var timeIntervalMinutesPicker = 30

        @Published var dailyTimes: [Date] = []
        @Published var weekDays: [WeeklyReminder] = []

        var isEditing = false

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
            switch reminderTypeData {

            case .oneTime(time: let time):
                self.oneTimeTime = time

            case .hourly(interval: let interval):
//                self.hourlyIntervalTime = .init(
//                    hour: interval.secondsToHoursAndMinutes().hours,
//                    minute: interval.secondsToHoursAndMinutes().minutes
//                )
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

        // MARK: - Reacting
//        func hoursIntervalChanged(_ newValue: Int) {
//            if timeIntervalMinutesPicker == 0 && newValue == 0 { timeIntervalMinutesPicker = 1 }
//            self.hourlyTimeInterval += newValue.hoursToSeconds()
//        }
//
//        func minutesIntervalChanged(_ newValue: Int) {
//            if timeIntervalHoursPicker == 0 { timeIntervalMinutesPicker = 1}
//            self.hourlyTimeInterval += newValue.minutesToSeconds()
//        }

        func createWeekDay() {
            weekDays.append(WeeklyReminder(dayOfTheWeekInt: 1, dates: []))
        }

        // MARK: User Intent(s)
        func save() {
            switch reminderType {
            case .oneTime:
                dataController.createOrUpdateOneTimeReminder(
                    title: title, time: oneTimeTime, reminder: isEditing ? reminder : nil
                )
            case .hourly:
                print("🔥 interval is \(hourlyDuration)")
                dataController.createOrUpdateHourlyReminder(
                    title: title, interval: Int(hourlyDuration), reminder: isEditing ? reminder : nil
                )
            case .daily:
                dataController.createOrUpdateDailyReminder(
                    title: title, times: dailyTimes, reminder: isEditing ? reminder : nil)

            case .weekly:
                dataController.createOrUpdateWeeklyReminder(
                    title: title,
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
        var dayOfTheWeekStr: String { Reminder.getWeekDayStr(for: dayOfTheWeekInt).full }
        var dayOfTheWeekInt: Int
        var dates: [Date]
        var times: [String] { dates.map({ $0.getTimeAndDate().time }) }
    }
}
