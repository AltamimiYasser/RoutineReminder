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

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                action()
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
            }
        }
    }
}
