//
//  EditReminderView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import SwiftUI

struct EditReminderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel

    init(dataController: DataController, reminder: Reminder? = nil) {
        let viewModel = ViewModel(dataController: dataController, reminder: reminder)
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
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
//                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Section("Time(s)") {
                    switch viewModel.reminderType {
                    case .oneTime:
                        DatePicker("Time", selection: $viewModel.oneTimeTime)

                    case .hourly:
                        Text("How often do you want to be reminded?")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        DurationPicker(duration: $viewModel.hourlyDuration)
//                        HourlyReminderEditView(time: $viewModel.hourlyIntervalTime)

                    case .daily:
                        DailyReminderEditView(
                            dailyTimes: $viewModel.dailyTimes,
                            onDelete: viewModel.deleteTimeFromDailyTimes
                        )

                    case .weekly:
                        WeeklyReminderEditView(
                            viewModel: viewModel,
                            createWeekDay: viewModel.createWeekDay,
                            save: viewModel.save
                        )
                    }
                }
                // if in the new reminder sheet and not editing an existing reminder
            }
            Button(viewModel.isEditing ? "Update" : "Save") {
                viewModel.save()
                    dismiss()
            }
        }
        .padding(.bottom)
        .toolbar {
            if viewModel.reminderType == .daily || viewModel.reminderType == .weekly {
                EditButton()
            }
        }
//        .onChange(of: viewModel.timeIntervalHoursPicker, perform: viewModel.hoursIntervalChanged)
//        .onChange(of: viewModel.timeIntervalMinutesPicker, perform: viewModel.minutesIntervalChanged)
//        .onDisappear(perform: {
//            if viewModel.isEditing { viewModel.save() }
//        })
        .navigationTitle("Edit Reminder")
    }

}
