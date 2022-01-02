//
//  CoreDataManager+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

extension DataController {

    private func createOrUpdateReminder(
        withTitle title: String,
        type: ReminderType,
        reminder: Reminder? = nil
    ) {

        if let reminder = reminder {
            reminder.title = title
            reminder.reminderType = type
        } else {
            let reminder = Reminder(context: context)
            reminder.title = title
            reminder.reminderType = type
            reminder.creationDate = Date()
        }
        save()
    }

    func createOrUpdateOneTimeReminder(title: String, time: Date, reminder: Reminder? = nil) {
        let oneTime = ReminderTypeOneTime(context: context)
        oneTime.time = time

        // type
        let reminderType = ReminderType(context: context)
        reminderType.oneTime = oneTime

        // reminder
        createOrUpdateReminder(withTitle: title, type: reminderType, reminder: reminder)
    }

    func createOrUpdateHourlyReminder(title: String, interval: Int, reminder: Reminder? = nil) {
        let hourly = ReminderTypeHourly(context: context)
        hourly.interval = Int64(interval)

        // type
        let reminderType = ReminderType(context: context)
        reminderType.hourly = hourly

        // reminder
        createOrUpdateReminder(withTitle: title, type: reminderType, reminder: reminder)
    }

    func createOrUpdateDailyReminder(title: String, times: [Date], reminder: Reminder? = nil) {
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
        createOrUpdateReminder(withTitle: title, type: reminderType, reminder: reminder)
    }

    // In weekly Reminder we link the dayOfTheWeek field to the times
     //                                                 [dayOfWeek:[times]]
    func createOrUpdateWeeklyReminder(title: String, daysAndTimes: [Int: [Date]], reminder: Reminder? = nil) {
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
        createOrUpdateReminder(withTitle: title, type: reminderType, reminder: reminder)
    }

    // In Monthly Reminder we link the date field to the times
    func createOrUpdateMonthlyReminder(
        title: String,
        times: [Date: [Date]], // [date:[times]]
        reminder: Reminder? = nil
    ) {
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
            monthly.addToDays(newDay)
        }

        let reminderType = ReminderType(context: context)
        reminderType.monthly = monthly

        // reminder
        createOrUpdateReminder(withTitle: title, type: reminderType, reminder: reminder)
    }

    func createSampleData() throws {
        createOrUpdateOneTimeReminder(title: "First Reminder", time: Date())
        createOrUpdateHourlyReminder(title: "SecondReminder", interval: (2.hoursToSeconds()))

        // times for daily
        let time1 = Date()
        let time2 = Date().addingTimeInterval(TimeInterval(14.hoursToSeconds()))
        createOrUpdateDailyReminder(title: "Third Reminder", times: [time1, time2])

        // weekly
        // Create days
        let times1 = [Date(), Date().addingTimeInterval(TimeInterval(6.hoursToSeconds()))]
        let times2 = [Date(), Date().addingTimeInterval(TimeInterval(12.hoursToSeconds()))]
        createOrUpdateWeeklyReminder(title: "Fourth Reminder", daysAndTimes: [1: times1, 5: times2])

        // MONTHLY
        // day with time
        let day1 = Date().addingTimeInterval(TimeInterval(9.daysToSeconds()))
        let day2 = Date().addingTimeInterval(TimeInterval(22.daysToSeconds()))
        createOrUpdateMonthlyReminder(title: "Fifth Reminder", times: [day1: times1, day2: times2])
    }
}
