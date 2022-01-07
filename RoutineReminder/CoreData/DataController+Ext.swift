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
        message: String?,
        type: ReminderType,
        reminder: Reminder? = nil
    ) {

        let reminder = reminder ?? Reminder(context: context)

        reminder.title = title
        reminder.message = message
        reminder.reminderType = type
        reminder.creationDate = Date()

        switch reminder.typeData {

        case .oneTime(time: let time):
            notificationManager.createOneTimeReminder(
                title: title,
                date: time,
                message: message,
                id: reminder.objectID.uriRepresentation().absoluteString
            ) { error in
                if let error = error {
                    fatalError("🔥 Error creating one time reminder \(error.localizedDescription)")
                }
            }

            // TODO: -
        case .hourly(interval: let interval):
            print("create reminder \(interval)")
        case .daily(times: let times):
            print("create reminder \(times)")
        case .weekly(days: let days):
            print("create reminder \(days)")
        }

        save()
    }

    func createOrUpdateOneTimeReminder(
        title: String,
        time: Date,
        message: String?,
        reminder: Reminder? = nil
    ) {
        let oneTime = ReminderTypeOneTime(context: context)
        oneTime.time = time

        // type
        let reminderType = ReminderType(context: context)
        reminderType.oneTime = oneTime

        // delete everything else
        delete(reminderType.hourly)
        delete(reminderType.daily)
        delete(reminderType.weekly)

        // reminder
        createOrUpdateReminder(withTitle: title, message: message, type: reminderType, reminder: reminder)
    }

    func createOrUpdateHourlyReminder(
        title: String,
        message: String?,
        interval: Int,
        reminder: Reminder? = nil
    ) {
        let hourly = ReminderTypeHourly(context: context)
        hourly.interval = Int64(interval)

        // type
        let reminderType = ReminderType(context: context)
        reminderType.hourly = hourly

        // delete everything else
        delete(reminderType.oneTime)
        delete(reminderType.daily)
        delete(reminderType.weekly)

        // reminder
        createOrUpdateReminder(withTitle: title, message: message, type: reminderType, reminder: reminder)
    }

    func createOrUpdateDailyReminder(
        title: String,
        message: String?,
        times: [Date],
        reminder: Reminder? = nil
    ) {
        let daily = ReminderTimeDaily(context: context)

        // add times
        for time in times {
            let newTime = Time(context: context)
            newTime.date = time
            daily.addToTimes(newTime)
        }

        let reminderType = ReminderType(context: context)
        reminderType.daily = daily

        // delete everything else
        delete(reminderType.oneTime)
        delete(reminderType.hourly)
        delete(reminderType.weekly)

        // reminder
        createOrUpdateReminder(withTitle: title, message: message, type: reminderType, reminder: reminder)
    }

    // In weekly Reminder we link the dayOfTheWeek field to the times
    //                                                 [dayOfWeek:[times]]
    func createOrUpdateWeeklyReminder(
        title: String,
        message: String?,
        daysAndTimes: [Int: [Date]],
        reminder: Reminder? = nil
    ) {
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

        // delete everything else
        delete(reminderType.oneTime)
        delete(reminderType.hourly)
        delete(reminderType.daily)

        // reminder
        createOrUpdateReminder(withTitle: title, message: message, type: reminderType, reminder: reminder)
    }

    func createSampleData() throws {
        createOrUpdateOneTimeReminder(
            title: "First Reminder",
            time: Date(),
            message: "first reminder description"
        )

        createOrUpdateHourlyReminder(
            title: "SecondReminder",
            message: "second reminder description",
            interval: (2.hoursToSeconds())
        )

        // times for daily
        let time1 = Date()
        let time2 = Date().addingTimeInterval(TimeInterval(14.hoursToSeconds()))
        createOrUpdateDailyReminder(
            title: "Third Reminder",
            message: "third reminder description",
            times: [time1, time2]
        )

        // weekly
        // Create days
        let times1 = [Date(), Date().addingTimeInterval(TimeInterval(6.hoursToSeconds()))]
        let times2 = [Date(), Date().addingTimeInterval(TimeInterval(12.hoursToSeconds()))]
        createOrUpdateWeeklyReminder(
            title: "Fourth Reminder",
            message: "fourth reminder description",
            daysAndTimes: [1: times1, 5: times2]
        )
    }
}
