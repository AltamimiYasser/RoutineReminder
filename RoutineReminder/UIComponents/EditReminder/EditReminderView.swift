//
//  EditReminderView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import SwiftUI

struct EditReminderView: View {
    @StateObject private var viewModel: ViewModel

    init(dataController: DataController, reminder: Reminder?) {
        let viewModel = ViewModel(dataController: dataController, reminder: reminder)
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section("General") {
                TextField("Title", text: $viewModel.title)
            }

            Section("Reminder Type") {
                Picker("Reminder Type", selection: $viewModel.reminderType) {
                    ForEach(Reminder.TypeOfReminder.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Time(s)") {
                switch viewModel.reminderType {
                case .oneTime:
                    DatePicker("Time", selection: $viewModel.oneTimeTime)

                case .hourly:
                    HourlyReminderEditView(
                        timeIntervalHoursPicker: $viewModel.timeIntervalHoursPicker,
                        timeIntervalMinutesPicker: $viewModel.timeIntervalMinutesPicker
                    )

                case .daily:
                    DailyReminderEditView(
                        dailyTimes: $viewModel.dailyTimes,
                        onDelete: viewModel.deleteTimeFromDailyTimes
                    )

                case .weekly:
                    WeeklyReminderEditView(weekDays: $viewModel.weekDays, createWeekDay: viewModel.createWeekDay)
                }
            }
        }
        .toolbar {
            if viewModel.reminderType == .daily || viewModel.reminderType == .weekly {
                EditButton()
            }
        }
        .onChange(of: viewModel.timeIntervalHoursPicker, perform: viewModel.hoursIntervalChanged)
        .onChange(of: viewModel.timeIntervalMinutesPicker, perform: viewModel.minutesIntervalChanged)
        .onDisappear(perform: viewModel.save)
        .navigationTitle("Edit Reminder")
    }

}
