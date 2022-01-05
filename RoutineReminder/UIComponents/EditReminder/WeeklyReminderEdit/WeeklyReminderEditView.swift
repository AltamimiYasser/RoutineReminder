//
//  WeeklyReminderEditView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 05/01/2022.
//

import SwiftUI

struct WeeklyReminderEditView: View {
    @Binding var weekDays: [EditReminderView.WeeklyReminder]
    var createWeekDay: () -> Void

    var body: some View {
        List {
            ForEach($weekDays, id: \.dayOfTheWeekStr) { $day in
                NavigationLink(isActive: $day.isActive) {
                    WeeklySingleDayEditView(weekday: $day)
                } label: {
                    VStack(alignment: .leading) {
                        Text(day.dayOfTheWeekStr)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(day.times.indices, id: \.self) { index in
                                    SmallCardView(string: day.times[index])
                                }
                            }
                        }
                    }
                }
            }
            .onDelete(perform: delete)

            Button {
                withAnimation {
                    createWeekDay()
                }
            } label: {
                Text("Add Reminder")
            }

        }
    }

    private func delete(_ offsets: IndexSet) {
        weekDays.remove(atOffsets: offsets)
    }
}
