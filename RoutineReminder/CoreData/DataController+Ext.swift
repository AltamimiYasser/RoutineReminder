//
//  CoreDataManager+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

extension DataController {

    private func createNotification(
        withTitle title: String,
        message: String?,
        type: Reminder.TypeOfReminderData,
        id: String,
        completion: @escaping (Error?) -> Void
    ) {
        switch type {
        case .oneTime(time: let time):
            notificationManager.createOneTimeReminder(
                title: title,
                message: message,
                date: time,
                id: id,
                completion: completion
            )
        case .hourly(interval: let interval):
            notificationManager.createHourlyReminder(
                title: title,
                message: message,
                interval: interval,
                id: id, completion: completion
            )
        case .daily(times: let times):
            notificationManager.createDailyReminder(
                title: title,
                message: message,
                times: times,
                id: id,
                completion: completion
            )
        case .weekly(days: let days):
            notificationManager.createWeeklyReminder(
                title: title,
                message: message,
                days: days,
                id: id,
                completion: completion
            )
        }
    }

    private func createOrUpdateReminder(
        withTitle title: String,
        message: String?,
        type: ReminderType,
        reminder: Reminder? = nil
    ) {
        let reminder = reminder ?? Reminder(context: context)
        func completion(error: Error?) {
            if let error = error { fatalError("🔥 Error creating one time reminder \(error.localizedDescription)") }
        }
        var id = ""
        if (try? context.obtainPermanentIDs(for: [reminder])) != nil {
            id = reminder.objectID.uriRepresentation().absoluteString } else {
            fatalError("Error assigning id")
        }
        reminder.title = title
        reminder.message = message
        reminder.reminderType = type
        reminder.creationDate = Date()

        notificationManager.deleteNotifications(withID: [id], type: reminder.typeData)
        if reminder.isEnabled {
            createNotification(
                withTitle: title,
                message: message,
                type: reminder.typeData,
                id: id,
                completion: completion
            )
        }
        save()
    }

    func refreshReminder(reminder: Reminder, enabled: Bool = true) {
        let title = reminder.title ?? ""
        let message = reminder.message
        let reminderType = ReminderType(context: context)
        reminderType.oneTime = ReminderTypeOneTime(context: context)
        reminderType.oneTime?.time = Date()
        let type = reminder.reminderType ?? reminderType
        reminder.isEnabled = enabled

        createOrUpdateReminder(withTitle: title, message: message, type: type, reminder: reminder)
    }

    func reloadAllNotifications() {
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Reminder.creationDate, ascending: true)]
        let reminders = try? context.fetch(fetchRequest)

        if let reminders = reminders {
            for reminder in reminders {
                refreshReminder(reminder: reminder)
            }
        }
    }

    func createOrUpdateOneTimeReminder(
        title: String,
        time: Date,
        message: String?,
        reminder: Reminder? = nil
    ) {
        let oneTime = ReminderTypeOneTime(context: context)
        oneTime.time = time

        let reminderType = ReminderType(context: context)
        reminderType.oneTime = oneTime

        if let reminder = reminder {
            delete(reminderType.hourly, type: reminder.typeData)
            delete(reminderType.daily, type: reminder.typeData)
            delete(reminderType.weekly, type: reminder.typeData)
        }

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

        let reminderType = ReminderType(context: context)
        reminderType.hourly = hourly

        if let reminder = reminder {
            delete(reminderType.oneTime, type: reminder.typeData)
            delete(reminderType.daily, type: reminder.typeData)
            delete(reminderType.weekly, type: reminder.typeData)
        }

        createOrUpdateReminder(withTitle: title, message: message, type: reminderType, reminder: reminder)
    }

    func createOrUpdateDailyReminder(
        title: String,
        message: String?,
        times: [Date],
        reminder: Reminder? = nil
    ) {
        let daily = ReminderTimeDaily(context: context)

        for time in times {
            let newTime = Time(context: context)
            newTime.date = time
            daily.addToTimes(newTime)
        }

        let reminderType = ReminderType(context: context)
        reminderType.daily = daily

        if let reminder = reminder {
            delete(reminderType.oneTime, type: reminder.typeData)
            delete(reminderType.hourly, type: reminder.typeData)
            delete(reminderType.weekly, type: reminder.typeData)
        }

        createOrUpdateReminder(withTitle: title, message: message, type: reminderType, reminder: reminder)
    }

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

        let reminderType = ReminderType(context: context)
        reminderType.weekly = weekly

        if let reminder = reminder {
            delete(reminderType.oneTime, type: reminder.typeData)
            delete(reminderType.hourly, type: reminder.typeData)
            delete(reminderType.daily, type: reminder.typeData)
        }

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

        let time1 = Date()
        let time2 = Date().addingTimeInterval(TimeInterval(14.hoursToSeconds()))
        createOrUpdateDailyReminder(
            title: "Third Reminder",
            message: "third reminder description",
            times: [time1, time2]
        )

        let times1 = [Date(), Date().addingTimeInterval(TimeInterval(6.hoursToSeconds()))]
        let times2 = [Date(), Date().addingTimeInterval(TimeInterval(12.hoursToSeconds()))]
        createOrUpdateWeeklyReminder(
            title: "Fourth Reminder",
            message: "fourth reminder description",
            daysAndTimes: [1: times1, 5: times2]
        )
    }
}
