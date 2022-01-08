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
                Section {
                    TextField("Title", text: $viewModel.title)
                    TextField("Description", text: $viewModel.message)
                } header: {
                    Text("General")
                }

                Section {
                    Picker("Reminder Type", selection: $viewModel.reminderType) {
                        ForEach(Reminder.TypeOfReminder.allCases, id: \.self) { type in
                            Text(type.rawValue).font(.headline)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Reminder Type")
                }

                Section {
                    switch viewModel.reminderType {
                    case .oneTime:
                        DatePicker("Time", selection: $viewModel.oneTimeTime, in: Date()...)
                            .labelsHidden()

                    case .hourly:
                        Text("How often do you want to be reminded?")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        DurationPicker(duration: $viewModel.hourlyDuration)

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
                } header: {
                    Text(viewModel.reminderType == .oneTime ? "Time" : "Times")
                } footer: {
                    Text(viewModel.footerDescription)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.bottom)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            CustomBackButtonView(dismiss: dismiss, action: viewModel.save)
        }
        .navigationTitle(viewModel.isEditing ? "Edit Reminder" : "New Reminder")
    }
}
