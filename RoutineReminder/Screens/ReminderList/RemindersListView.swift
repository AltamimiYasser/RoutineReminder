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

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.reminders) { reminder in
                    Text(reminder.reminderTitle)
                }
                .onDelete(perform: viewModel.delete)
            }
            HStack {
                Button("Generate Sample Data", action: viewModel.generateSampleData)
                Button("Delete All", action: viewModel.deleteAll)
            }
        }
        .overlay(overLay)
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
