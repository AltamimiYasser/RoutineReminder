//
//  Int+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 01/01/2022.
//

import Foundation

extension Int {
    func hoursToSeconds() -> Int { self * 3600 }
    func minutesToSeconds() -> Int { self * 60 }

    func secondsToHoursAndMinutes() -> (hours: Int, minutes: Int) {
        (self / 3600, (self % 3600) / 60)
    }
}
