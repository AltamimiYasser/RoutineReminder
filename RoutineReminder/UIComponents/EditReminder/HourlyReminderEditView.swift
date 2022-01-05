//
//  HourlyReminderEditView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 05/01/2022.
//

import SwiftUI

struct HourlyReminderEditView: View {
    @Binding var timeIntervalHoursPicker: Int
    @Binding var timeIntervalMinutesPicker: Int
    var minMinutes: Int { timeIntervalHoursPicker == 0 ? 1 : 0}
    var body: some View {
        VStack(alignment: .leading) {
            Text("How often do you want to be reminded?")
                .font(.callout)
                .foregroundColor(.secondary)
            HStack {
                Text("Hours")
                Spacer()
                Picker("Hours:", selection: $timeIntervalHoursPicker) {
                    ForEach((0...23).reversed(), id: \.self) { num in
                        Text("\(num)").tag(num)
                            .font(.headline)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.trailing)

            HStack {
                Text("Minutes")
                Spacer()
                Picker("Minutes:", selection: $timeIntervalMinutesPicker) {
                    ForEach((minMinutes...59).reversed(), id: \.self) { num in
                        Text("\(num)").tag(num)
                            .font(.headline)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.trailing)
        }
    }
}
