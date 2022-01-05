//
//  WeeklySingleDayEditView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 05/01/2022.
//

import SwiftUI

struct WeeklySingleDayEditView: View {
    @Binding var weekday: EditReminderView.WeeklyReminder

    var body: some View {
        Form {
            Section("Weekday") {
                Picker("Weekday", selection: $weekday.dayOfTheWeekInt) {
                    ForEach(1..<8) { weekDayInt in
                        Text(Reminder.getWeekDayStr(for: weekDayInt).full).tag(weekDayInt)
                    }

                }
                .pickerStyle(.menu)
            }

            Section("Time(s)") {

                ForEach(weekday.dates.indices, id: \.self) { index in
                    DatePicker(
                        "\(index + 1)",
                        selection: $weekday.dates[index],
                        displayedComponents: .hourAndMinute
                    )
                        .labelsHidden()
                }
                .onDelete(perform: delete)

                Label("Add", systemImage: "plus.circle")
                    .frame(minWidth: 100, minHeight: 35)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 4)) {
                            weekday.dates.append(Date())
                        }
                    }
            }
        }
        .navigationTitle("\(weekday.dayOfTheWeekStr) Reminders")
    }

    private func delete(_ offsets: IndexSet) {
        weekday.dates.remove(atOffsets: offsets)
    }
}
