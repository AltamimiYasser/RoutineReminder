//
//  CustomBackButtonView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 06/01/2022.
//

import SwiftUI

struct CustomBackButtonView: ToolbarContent {

    let dismiss: DismissAction
    let action: () -> Void

    init(dismiss: DismissAction, action: @escaping () -> Void = {}) {
        self.dismiss = dismiss
        self.action = action
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                action()
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrowshape.turn.up.backward")
                    Text("Back")
                }
            }
        }
    }
}
