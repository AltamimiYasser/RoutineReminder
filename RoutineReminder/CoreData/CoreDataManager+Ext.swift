//
//  CoreDataManager+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

extension DataController {

    private func createReminder(withTitle title: String, type: ReminderType) -> Reminder {
        let reminder = Reminder(context: context)
        reminder.title = title
        reminder.reminderType = type
        reminder.creationDate = Date()
        return reminder
    }

    func createOneTimeReminder(title: String, time: Date) {
        let oneTime = ReminderTypeOneTime(context: context)
        oneTime.time = time

        // type
        let reminderType = ReminderType(context: context)
        reminderType.oneTime = oneTime

        // reminder
        _ = createReminder(withTitle: title, type: reminderType)
        save()
    }

    func createHourlyReminder(title: String, interval: Int) {
        let hourly = ReminderTypeHourly(context: context)
        hourly.interval = Int64(interval)

        // type
        let reminderType = ReminderType(context: context)
        reminderType.hourly = hourly

        // reminder
        _ = createReminder(withTitle: title, type: reminderType)
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
        _ = createReminder(withTitle: title, type: reminderType)
        save()
    }

    // In weekly Reminder we link the dayOfTheWeek field to the times
    func createWeeklyReminder(title: String, daysAndTimes: [Int: [Date]]) { // [dayOfWeek:[times]]
        let weekly = ReminderTypeWeekly(context: context)

        for (day, times) in daysAndTimes {
            let newDay = Day(context: context)
            newDay.dayOfTheWeek = Int64(day)

            for time in times {
                let newTime = Time(context: context)
                newTime.date = time
                newDay.addToTimes(newTime)
            }

            weekly.addToDays(newDay)
        }

        // type
        let reminderType = ReminderType(context: context)
        reminderType.weekly = weekly

        // reminder
        _ = createReminder(withTitle: title, type: reminderType)
        save()
    }

    // In Monthly Reminder we link the date field to the times
    func createMonthlyReminder(title: String, times: [Date: [Date]]) { // [date:[times]]
        let monthly = ReminderTypeMonthly(context: context)

        // we don't need day of the week so we keep it at nil
        for (day, times) in times {
            // for everyday create a day object
            let newDay = Day(context: context)
            newDay.date = day
            for time in times {
            // for every time create a time
                let newTime = Time(context: context)
                newTime.date = time
                newDay.addToTimes(newTime)
            }
        }

        let reminderType = ReminderType(context: context)
        reminderType.monthly = monthly

        // reminder
        _ = createReminder(withTitle: title, type: reminderType)
        save()
    }

    func createSampleData() throws {
        createOneTimeReminder(title: "First Reminder", time: Date())
        createHourlyReminder(title: "SecondReminder", interval: 30 * 60) // 30 minutes from now

        // times for daily
        let time1 = Date()
        let time2 = Date().addingTimeInterval(48 * 3600) // 2 days from now
        createDailyReminder(title: "Third Reminder", times: [time1, time2])

        // weekly
        // Create days
        let times1 = [Date(), Date().addingTimeInterval(TimeInterval(6.hoursToSeconds()))]
        let times2 = [Date(), Date().addingTimeInterval(TimeInterval(12.hoursToSeconds()))]
        createWeeklyReminder(title: "Fourth Reminder", daysAndTimes: [1: times1, 5: times2])

        // MONTHLY
        // day with time
        let day1 = Date()
        let day2 = Date().addingTimeInterval(12 * 60)
        createMonthlyReminder(title: "Fifth Reminder", times: [day1: times1, day2: times2])
    }
}
