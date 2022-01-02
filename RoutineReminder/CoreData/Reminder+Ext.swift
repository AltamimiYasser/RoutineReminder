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
                let newTime = time as? Time
                let time = newTime?.date ?? Date() as Date
                arrTimes.append(time)
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
                dictDays[dayOfWeek] = []
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
                    arrTimes[date] = []
                    arrTimes[date]?.append(exactTime)
                }

            }

            return .monthly(days: arrTimes)
        }

        let time = reminderType?.oneTime?.time
            return .oneTime(time: time ?? Date())
    }

    enum TypeOfReminder {
        case oneTime(time: Date)
        case hourly(interval: Int)
        case daily(times: [Date])
        case weekly(days: [Int: [Date]])
        case monthly(days: [Date: [Date]])

        var description: String {
            switch self {
            case .oneTime:
                return "One Time"
            case .hourly:
                return "Hourly"
            case .daily:
                return "Daily"
            case .weekly:
                return "Weekly"
            case .monthly:
                return "Monthly"
            }
        }

    }

    static func getWeekDayStr(for dayOfWeek: Int) -> (full: String, short: String) {
            switch dayOfWeek {
            case 1:
                return ("Sunday", "Sun")
            case 2:
                return ("Monday", "Mon")
            case 3:
                return ("Tuesday", "Tu")
            case 4:
                return ("Wednesday", "Wed")
            case 5:
                return ("Thursday", "Th")
            case 6:
                return ("Friday", "Fri")
            case 7:
                return ("Saturday", "Sat")
            default:
                return ("Error", "Error")
            }
        }

    static var example: Reminder {
        let controller = DataController.preview

        let time1 = Time(context: controller.context)
        time1.date = Date()
        let time2 = Time(context: controller.context)
        time2.date = Date().addingTimeInterval(TimeInterval(12.hoursToSeconds()))

        let day1 = Day(context: controller.context)
        day1.dayOfTheWeek = 1
        day1.addToTimes([time1, time2])

        let time3 = Time(context: controller.context)
        time3.date = Date()
        let time4 = Time(context: controller.context)
        time4.date = Date().addingTimeInterval(TimeInterval(12.hoursToSeconds()))

        let day2 = Day(context: controller.context)
        day2.dayOfTheWeek = 1
        day2.addToTimes([time1, time2])

        let weekly = ReminderTypeWeekly(context: controller.context)
        weekly.addToDays([day1, day2])

        let type = ReminderType(context: controller.context)
        type.weekly = weekly
        let reminder = Reminder(context: controller.context)
        reminder.reminderType = type
        reminder.title = "Example Reminder"
        reminder.creationDate = Date()

        return reminder
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
