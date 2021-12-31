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
        if reminderType?.hourly != nil { return .hourly }
        if reminderType?.daily != nil { return .daily }
        if reminderType?.weekly != nil { return .weekly }
        if reminderType?.monthly != nil { return .monthly }
        return .oneTime
    }

    enum TypeOfReminder {
        case oneTime
        case hourly
        case daily
        case weekly
        case monthly
    }
}
