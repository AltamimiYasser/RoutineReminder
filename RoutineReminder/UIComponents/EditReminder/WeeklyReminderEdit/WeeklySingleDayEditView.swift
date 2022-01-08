//
//  WeeklySingleDayEditView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 05/01/2022.
//

import SwiftUI

struct WeeklySingleDayEditView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var weekday: EditReminderView.WeeklyReminder

    let save: () -> Void

    var body: some View {
        Self._printChanges()
        return Form {
            Section("Weekday") {
                Picker("Weekday", selection: $weekday.dayOfTheWeekInt) {
                    ForEach(1...7, id: \.self) { weekDayInt in
                        Text(Reminder.getWeekDayStr(for: weekDayInt).full).tag(weekDayInt)
                    }

                }
                .pickerStyle(.menu)
            }

            Section("Time(s)") {

                List {
                    ForEach(weekday.dates.indices, id: \.self) { index in
                        DatePicker(
                            "\(index + 1)",
                            selection: $weekday.dates[index],
                            displayedComponents: .hourAndMinute
                        )
                            .labelsHidden()
                    }
                    .onDelete(perform: delete)
                    Button("Add") {
                        withAnimation {
                            weekday.dates.append(Date())
                        }
                    }
                }
            }
        }
        .animation(.default, value: weekday.dates)
        .navigationTitle("\(weekday.dayOfTheWeekStr) Reminders")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            CustomBackButtonView(dismiss: dismiss)
        }
    }

    private func delete(_ offsets: IndexSet) {
        weekday.dates.remove(atOffsets: offsets)
    }
}
