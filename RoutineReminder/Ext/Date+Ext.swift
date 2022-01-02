//
//  Date+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import Foundation

extension Date {
    func getTimeAndDate() -> (time: String, date: String) {
        var result = (time: "", date: "")
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        result.time = formatter.string(from: self)
        formatter.dateFormat = "dd MMMM"
        result.date = formatter.string(from: self)
        return result
    }
}
