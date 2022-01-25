//
//  InfoOverlayView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 02/01/2022.
//

import SwiftUI

struct InfoOverlayView: View {
    @Environment(\.dismiss) private var dismiss
    let infoMessage: LocalizedStringKey
    let buttonTitle: LocalizedStringKey
    let systemImageName: String
    let action: () -> Void
    var withXMark = false

    var body: some View {
        VStack {
            Text(infoMessage)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Button {
                action()
            } label: {
                Label(buttonTitle, systemImage: systemImageName)
                    .font(.title)
            }
            .padding()
            .cornerRadius(5)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if withXMark {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
            }
        }
    }
}
