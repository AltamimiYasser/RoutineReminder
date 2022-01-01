//
//  Reminder+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import Foundation
import CoreData

extension Reminder {
    var reminderTitle: String { title ?? "No name provided"}

    var type: Reminder.TypeOfReminder {
        if reminderType?.hourly != nil {
            return .hourly(
                interval: Int(
                    reminderType?.hourly?.interval ?? Int64(30.minutesToSeconds()) // default to every half an hour
                )
            )
        }

        if reminderType?.daily != nil {
            let times = reminderType?.daily?.times
            var arrTimes = [Date]()
            for time in times ?? [] {
                arrTimes.append(time as? Date ?? Date())
            }
            return .daily(times: arrTimes)
        }

        if reminderType?.weekly != nil {
            let days = reminderType?.weekly?.days // Day(s)
            var dictDays = [Int: [Date]]()

            for day in days ?? [] {
                let day = day as? Day
                let dayOfWeek = Int(day?.dayOfTheWeek ?? Int64(-1)) // default to -1 so we know something is wrong
                let times = day?.times
                dictDays[dayOfWeek]?.append(contentsOf: getTimes(for: times))
            }

            return .weekly(days: dictDays)
        }

        if reminderType?.monthly != nil {
            let days = reminderType?.monthly?.days
            var arrTimes = [Date: [Date]]()

            for day in days ?? [] {
                let day = day as? Day
                let date = day?.date ?? Date()
                let times = day?.times

                for time in times ?? [] {
                    let newTime = time as? Time
                    let exactTime = newTime?.date ?? Date()
                    arrTimes[date]?.append(exactTime)
                }

            }

            return .monthly(days: arrTimes)
        }

        return .oneTime(time: reminderType?.oneTime?.time ?? Date())
    }

    enum TypeOfReminder {
        case oneTime(time: Date)
        case hourly(interval: Int)
        case daily(times: [Date])
        case weekly(days: [Int: [Date]])
        case monthly(days: [Date: [Date]])
    }
}

// MARK: - helper functions
extension Reminder {
    /// Convert a set of type NSSet to Time instances and return the dates in those instances
    /// - Parameter times: NSSet which should contain instances of type Time
    /// - Returns: a Date array of the times related to these instances
    private func getTimes(for times: NSSet?) -> [Date] {
        var resultTimes = [Date]()
        for time in times ?? [] {
            let time = time as? Time // the class time
            let exactTime = time?.date // the property time inside Time
            resultTimes.append(exactTime ?? Date())
        }
        return resultTimes
    }
}
