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
        .onChange(of: viewModel.isEnabled, perform: viewModel.save)
    }

}

extension ReminderRowView {
    var leftSide: some View {
        Group {
            switch reminder.typeData {
            case .oneTime(let time):
                getLeftSideView(subTitle: "One time Reminder") {
                    HStack {
                        SmallCardView(string: time.getTimeAndDate().date)
                        SmallCardView(string: time.getTimeAndDate().time)
                    }
                    .font(.headline)
                }

            case .hourly(let interval):
                let (hours, minutes) = interval.secondsToHoursAndMinutes()
                if hours == 0 {
                    getLeftSideView(subTitle: "Repeats every") {
                        SmallCardView(string: "\(minutes) minutes")
                    }
                } else {
                    getLeftSideView(subTitle: "Repeats every") {
                        SmallCardView(string: "\(hours) hours and \(minutes)")
                    }
                }

            case .daily(let times):
                getLeftSideView(subTitle: "Repeats everyday at") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(times, id: \.self) { time in
                                SmallCardView(string: time.getTimeAndDate().time)
                            }
                        }
                    }
                }

            case .weekly(let days):
                getLeftSideView(subTitle: "Repeats weekly every") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(days.sorted(by: {$0.key > $1.key}), id: \.key) { day, _ in
                                SmallCardView(string: Reminder.getWeekDayStr(for: day).short)
                            }
                        }
                    }

                }

            case .monthly(days: let days):
                getLeftSideView(subTitle: "Repeats monthly every") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(days.sorted(by: {$0.key > $1.key}), id: \.key) { day, _ in
                                SmallCardView(string: day.getTimeAndDate().date)
                            }
                        }
                    }
                }
            }
        }
    }

    func getLeftSideView<Content: View>(subTitle: String, @ViewBuilder content: () -> Content) -> some View {
        Group {
            VStack(alignment: .leading) {
                Text(subTitle)
                    .font(.callout)
                    .foregroundColor(.secondary)
                content()
            }
            .padding(.horizontal)
        }
    }
}

struct ReminderRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderRowView(reminder: Reminder.example, dataController: DataController.preview)
    }
}
