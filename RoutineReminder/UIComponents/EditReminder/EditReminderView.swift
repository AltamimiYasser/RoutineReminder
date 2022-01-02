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
                Toggle("Repeating", isOn: $viewModel.repeated)
            }

            if !viewModel.repeated {
                Section {
                    DatePicker("Time", selection: $viewModel.oneTimeTime)
                }
            } else {
                Section("Reminder Type") {
                    Picker("Reminder Type", selection: $viewModel.reminderType) {
                        ForEach(Reminder.TypeOfReminder.allCases, id: \.self) { type in
                            Text(type.description)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Time") {
                }
            }
//            } else {
//                Picker("Reminder Type", selection: $viewModel.reminderType) {
//                    ForEach(Reminder.TypeOfReminder.allCases, id: \.self) { type in
//                        Text(type.description)
//                    }
//                }
//            }
        }
        .onChange(of: viewModel.reminderType, perform: viewModel.reminderTypeChanged)
        .onDisappear(perform: viewModel.save)
    }
}
