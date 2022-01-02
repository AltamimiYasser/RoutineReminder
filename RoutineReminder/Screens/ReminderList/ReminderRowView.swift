//
//  ReminderRowView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import SwiftUI

struct ReminderRowView: View {
    @StateObject private var viewModel: ViewModel
    private var reminder: Reminder { viewModel.reminder }

    init(reminder: Reminder, dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController, reminder: reminder)
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(reminder.reminderTitle)
                    .padding(.horizontal)
                    .font(.headline)
                leftSide
            }
            Spacer()
            Toggle("Enabled", isOn: $viewModel.isEnabled)
                .labelsHidden()
                .padding(.trailing, 10)
        }
        .onChange(of: viewModel.isEnabled) { _ in
            viewModel.save()
        }
    }

}

extension ReminderRowView {
    var leftSide: some View {
        Group {

            switch viewModel.reminder.type {
            case .oneTime(let time):
                HStack {
                    dateViewFor(stringDate: time.getTimeAndDate().time)
                    dateViewFor(stringDate: time.getTimeAndDate().date)
                }
                .font(.headline)
                .padding(.horizontal)

            case .hourly(let interval):
                let (hours, minutes) = interval.secondsToHoursAndMinutes()
                Group {
                    if hours == 0 {
                        Text("Repeats every")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        dateViewFor(stringDate: "\(minutes) minutes")
                    } else {
                        Text("Repeats every")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        dateViewFor(stringDate: "\(hours) hours and \(minutes)")
                    }
                }
                .padding(.horizontal)

            case .daily(let times):
                VStack(alignment: .leading) {
                    Text("Repeats everyday at")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(times, id: \.self) { time in
                                dateViewFor(stringDate: time.getTimeAndDate().time)
                            }
                        }
                    }
                }
                .padding(.horizontal)

            case .weekly(let days):
                VStack(alignment: .leading) {
                        Text("Repeats weekly every")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(days.sorted(by: {$0.key > $1.key}), id: \.key) { day, _ in
                                dateViewFor(stringDate: Reminder.getWeekDayStr(for: day).short)
                            }
                        }
                    }

                }
                .padding(.horizontal)

            case .monthly(days: let days):
                VStack(alignment: .leading) {
                    Text("Repeats montly every")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(days.sorted(by: {$0.key > $1.key}), id: \.key) { day, _ in
                                dateViewFor(stringDate: day.getTimeAndDate().date)
                            }
                        }
                    }

                }
                .padding(.horizontal)
            }
        }
    }

    func dateViewFor(stringDate: String) -> some View {
        Text(stringDate)
            .font(.headline)
            .foregroundColor(.white)
            .padding(10)
            .background(.purple)
            .cornerRadius(5)
            .shadow(radius: 8)
    }
}

struct ReminderRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderRowView(reminder: Reminder.example, dataController: DataController.preview)
    }
}
