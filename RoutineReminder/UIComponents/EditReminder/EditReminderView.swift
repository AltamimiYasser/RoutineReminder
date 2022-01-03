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
                    VStack(alignment: .leading) {
                        Text("How often do you want to be reminded?")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        HStack {
                            Text("Hours")
                            Spacer()
                            Picker("Hours:", selection: $viewModel.timeIntervalHoursPicker) {
                                ForEach((0...23).reversed(), id: \.self) { num in
                                    Text("\(num)").tag(num)
                                        .font(.headline)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        .padding(.trailing)

                        HStack {
                            Text("Minutes")
                            Spacer()
                            Picker("Minutes:", selection: $viewModel.timeIntervalMinutesPicker) {
                                ForEach((viewModel.minutesPickersRangeMin...59).reversed(), id: \.self) { num in
                                    Text("\(num)").tag(num)
                                        .font(.headline)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        .padding(.trailing)
                    }

                case .daily:
                    List {
                        ForEach(viewModel.dailyTimes.indices, id: \.self) { index in
                            DatePicker(
                                "\(index + 1)",
                                selection: $viewModel.dailyTimes[index],
                                displayedComponents: .hourAndMinute
                            )
                                .labelsHidden()
                        }
                        .onDelete(perform: delete)

                        Label("Add", systemImage: "plus.circle")
                            .frame(minWidth: 100, minHeight: 35)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.dailyTimes.append(Date())
                                }
                            }
                    }

                case .weekly:
                    List {
                        ForEach(viewModel.mappedWeekDays, id: \.dayOfTheWeek) { day in
                            NavigationLink {
                                Text(day.dayOfTheWeek) //TODO:
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(day.dayOfTheWeek)
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(day.times.indices, id: \.self) { index in
                                                SmallCardView(string: day.times[index])
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                case .monthly:
                    Text("monthly")
                }
            }
        }
        .toolbar {
            if case Reminder.TypeOfReminder.daily = viewModel.reminderType {
                EditButton()
            }
        }
        .onChange(of: viewModel.timeIntervalHoursPicker, perform: viewModel.hoursIntervalChanged)
        .onChange(of: viewModel.timeIntervalMinutesPicker, perform: viewModel.minutesIntervalChanged)
        .onDisappear(perform: viewModel.save) // TODO: Any navigation link will pop back
    }

    private func delete(at offsets: IndexSet) {
        withAnimation {
            viewModel.dailyTimes.remove(atOffsets: offsets)
        }
    }
}
