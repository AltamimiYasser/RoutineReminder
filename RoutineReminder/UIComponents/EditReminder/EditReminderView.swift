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
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section("General") {
                TextField("Title", text: $viewModel.title)
            }
        }
    }
}

struct EditReminderView_Previews: PreviewProvider {
    static var previews: some View {
        EditReminderView(dataController: DataController.preview, reminder: Reminder.example)
    }
}
