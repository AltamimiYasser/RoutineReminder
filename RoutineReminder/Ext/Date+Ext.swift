//
//  Date+Ext.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import Foundation
import SwiftUI

extension Date {
    func getTimeAndDate() -> (time: LocalizedStringKey, date: LocalizedStringKey) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = LocalizedStringKey(formatter.string(from: self))
        formatter.dateFormat = "dd MMMM"
        let date = LocalizedStringKey(formatter.string(from: self))
        return (time, date)
    }
}
