//
//  CoreDataManager+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

extension CoreDataManager {

    func createSampleData() throws {
        // ONE TIME
        // one time type
        let oneTime = ReminderTypeOneTime(context: context)
        oneTime.time = Date()

        // type
        let reminderType1 = ReminderType(context: context)
        reminderType1.oneTime = oneTime

        // reminder
        let reminder1 = Reminder(context: context)
        reminder1.title = "First Reminder"
        reminder1.reminderType = reminderType1

        // HOURLY
        // hourly
        let hourly = ReminderTypeHourly(context: context)
        hourly.interval = 30 * 60 // 30 minutes

        // type
        let reminderType2 = ReminderType(context: context)
        reminderType2.hourly = hourly

        // reminder
        let reminder2 = Reminder(context: context)
        reminder2.title = "Second Reminder"
        reminder2.reminderType = reminderType2

        // DAILY
        // times for daily
        let time1 = Time(context: context)
        time1.date = Date()

        let time2 = Time(context: context)
        time2.date = Date().addingTimeInterval(48 * 3600) // 2 days from now

        // daily
        let daily = ReminderTimeDaily(context: context)
        daily.addToTimes([time1, time2])

        // type
        let reminderType3 = ReminderType(context: context)
        reminderType3.daily = daily

        // reminder
        let reminder3 = Reminder(context: context)
        reminder3.reminderType = reminderType3

        // WEEKLY
        // Create days
        let day1 = Day(context: context)
        day1.dayOfTheWeek = 2
        day1.time = Date()

        let day2 = Day(context: context)
        day2.dayOfTheWeek = 5
        day2.time = Date().addingTimeInterval(12 * 60) // 12 hours from now

        let weekly = ReminderTypeWeekly(context: context)
        weekly.addToDays([day1, day2])

        // type
        let reminderType4 = ReminderType(context: context)
        reminderType4.weekly = weekly

        // reminder
        let reminder4 = Reminder(context: context)
        reminder4.reminderType = reminderType4

        // MONTHLY
        // day with time
        let day3 = Day(context: context)
        day3.time = Date()

        let day4 = Day(context: context)
        day4.time = Date().addingTimeInterval(2400 * 3600) // 24 days from now

        // monthly
        let monthly = ReminderTypeMonthly(context: context)
        monthly.addToDays([day3, day4])

        // type
        let reminderType5 = ReminderType(context: context)
        reminderType5.monthly = monthly

        // reminder
        let reminder5 = Reminder(context: context)
        reminder5.reminderType = reminderType5

        save()

    }
}
