//
//  DailyReminderEditView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 05/01/2022.
//

import SwiftUI

struct DailyReminderEditView: View {
    @Binding var dailyTimes: [Date]
    var onDelete: (IndexSet) -> Void

    var body: some View {
        List {
            ForEach(dailyTimes.indices, id: \.self) { index in
                DatePicker(
                    "\(index + 1)",
                    selection: $dailyTimes[index],
                    displayedComponents: .hourAndMinute
                )
                    .labelsHidden()
            }
            .onDelete(perform: onDelete)

            Label("Add", systemImage: "plus.circle")
                .frame(minWidth: 100, minHeight: 35)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
                .onTapGesture {
                    withAnimation {
                        dailyTimes.append(Date())
                    }
                }
        }
    }
}
