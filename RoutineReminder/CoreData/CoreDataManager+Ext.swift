//
//  CoreDataManager+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

extension DataController {

    private func createOneTimeReminder(title: String, time: Date) {
        // one time type
        let oneTime = ReminderTypeOneTime(context: context)
        oneTime.time = time

        // type
        let reminderType = ReminderType(context: context)
        reminderType.oneTime = oneTime

        // reminder
        let reminder = Reminder(context: context)
        reminder.title = title
        reminder.reminderType = reminderType

        reminder.objectWillChange.send()
        save()
    }

    private func createHourlyReminder(title: String, interval: Int) {
        // hourly
        let hourly = ReminderTypeHourly(context: context)
        hourly.interval = Int64(interval)

        // type
        let reminderType = ReminderType(context: context)
        reminderType.hourly = hourly

        // reminder
        let reminder = Reminder(context: context)
        reminder.title = title
        reminder.reminderType = reminderType

        save()
    }

    func createDailyReminder(title: String, times: [Date]) {
        let daily = ReminderTimeDaily(context: context)

        // add times
        for time in times {
            let newTime = Time(context: context)
            newTime.date = time
            daily.addToTimes(newTime)
        }

        let reminderType = ReminderType(context: context)
        reminderType.daily = daily

        // reminder
        let reminder = Reminder(context: context)
        reminder.title = title
        reminder.reminderType = reminderType

        save()
    }

    func createWeeklyReminder(title: String, daysAndTimes: [Int: Date]) {
        let weekly = ReminderTypeWeekly(context: context)

        for (day, time) in daysAndTimes {
            let newDay = Day(context: context)
            newDay.dayOfTheWeek = Int64(day)
            newDay.time = time
            weekly.addToDays(newDay)
        }

        let reminderType = ReminderType(context: context)
        reminderType.weekly = weekly

        // reminder
        let reminder = Reminder(context: context)
        reminder.title = title
        reminder.reminderType = reminderType

        save()
    }

    func createMonthlyReminder(title: String, times: [Date]) {
        let monthly = ReminderTypeMonthly(context: context)

        for time in times {
            let day = Day(context: context)
            day.time = time
        }

        let reminderType = ReminderType(context: context)
        reminderType.monthly = monthly

        // reminder
        let reminder = Reminder(context: context)
        reminder.title = title
        reminder.reminderType = reminderType

        save()
    }

    func createSampleData() throws {
        createOneTimeReminder(title: "First Reminder", time: Date())
        createHourlyReminder(title: "SecondReminder", interval: 30 * 60) // 30 minutes from now

        // times for daily
        let time1 = Date()
        let time2 = Date().addingTimeInterval(48 * 3600) // 2 days from now
        createDailyReminder(title: "Third Reminder", times: [time1, time2])

        // Create days
        let day1 = Date()
        let day2 = Date().addingTimeInterval(12 * 60)
        createWeeklyReminder(title: "Fourth Reminder", daysAndTimes: [2: day1, 5: day2])

        // MONTHLY
        // day with time
        let time3 = Date()
        let time4 = Date().addingTimeInterval(2400 * 3600) // 24 days from now
        createMonthlyReminder(title: "Fifth Reminder", times: [time3, time4])
    }
}
