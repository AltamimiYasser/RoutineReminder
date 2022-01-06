//
//  WeeklyReminderEditView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 05/01/2022.
//

import SwiftUI

struct WeeklyReminderEditView: View {
    @ObservedObject var viewModel: EditReminderView.ViewModel
    let createWeekDay: () -> Void
    let save: () -> Void

    var body: some View {
        List {
            ForEach(viewModel.weekDays.indices, id: \.self) { index in
                NavigationLink {
                    WeeklySingleDayEditView(weekday: $viewModel.weekDays[index], save: save)
                } label: {
                    VStack(alignment: .leading) {
                        Text(viewModel.weekDays[index].dayOfTheWeekStr)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.weekDays[index].times.indices, id: \.self) { index2 in
                                    SmallCardView(string: viewModel.weekDays[index].times[index2])
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
        viewModel.weekDays.remove(atOffsets: offsets)
    }
}
