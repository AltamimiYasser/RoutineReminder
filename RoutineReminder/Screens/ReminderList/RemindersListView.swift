//
//  RemindersListView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 31/12/2021.
//

import SwiftUI

struct RemindersListView: View {
    @StateObject private var viewModel: ViewModel
    @State private var showNewReminderSheet = false
    @State private var showEnableNotificationSheet = false
    private let dataController: DataController

    init(dataController: DataController, showNotificationSheet: Bool = false) {
        self.dataController = dataController
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = .init(wrappedValue: viewModel)
        _showEnableNotificationSheet = .init(initialValue: showNotificationSheet)
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.reminders) { reminder in
                    NavigationLink {
                        EditReminderView(dataController: dataController, reminder: reminder)
                    } label: {
                        ReminderRowView(dataController: dataController, reminder: reminder)
                    }
                }
                .onDelete(perform: viewModel.delete)
                .padding(.vertical)
                if !viewModel.reminders.isEmpty {
                    NavigationLink {
                        EditReminderView(dataController: dataController)
                    } label: {
                        Text("Add New Reminder")
                            .frame(minHeight: 100)
                            .font(.headline)
                            .padding(.horizontal)
                            .foregroundColor(.blue)
                    }
                }
            }
            .listStyle(.plain)
            .sheet(isPresented: $showEnableNotificationSheet, onDismiss: nil) {
                NavigationView {
                    InfoOverlayView(
                        infoMessage: "Please Enable Notification Permission In Settings",
                        buttonTitle: "Settings",
                        systemImageName: "gear",
                        action: openSettings,
                        withXMark: true
                    )
                }
            }
        }
        .toolbar {
            if !viewModel.reminders.isEmpty {
                EditButton()
            }
        }
        .overlay(overLay)
        .navigationTitle("Reminders")
        .sheet(isPresented: $showNewReminderSheet, onDismiss: nil) {
            NavigationView {
                EditReminderView(dataController: dataController)
            }
        }
    }

    private var overLay: some View {
        Group {
            if viewModel.reminders.isEmpty {
                InfoOverlayView(
                    infoMessage: "No Reminders Yet",
                    buttonTitle: "Add",
                    systemImageName: "plus.circle",
                    action: { showNewReminderSheet.toggle() }
                )
            }
        }
        .transition(.slide)
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
