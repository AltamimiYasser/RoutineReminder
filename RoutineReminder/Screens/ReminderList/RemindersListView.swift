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
    private let dataController: DataController

    init(dataController: DataController) {
        self.dataController = dataController
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.reminders) { reminder in
                    NavigationLink {
                        EmptyView()
                    } label: {
                        ReminderRowView(reminder: reminder, dataController: dataController)
                    }

                }
                .onDelete(perform: viewModel.delete)
                .padding(.vertical)
            }
            .listStyle(.plain)
            HStack {
                Button("Generate Sample Data", action: viewModel.generateSampleData)
                Button("Delete All", action: viewModel.deleteAll)
            }
        }
        .overlay(overLay)
        .navigationTitle("Reminders")
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
    }
}

struct RemindersListView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersListView(dataController: DataController.preview)
    }
}
