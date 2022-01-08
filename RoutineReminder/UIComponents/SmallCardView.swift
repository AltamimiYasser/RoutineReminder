//
//  SmallCardView.swift
//  RoutineReminder
//
//  Created by Yasser Tamimi on 03/01/2022.
//

import SwiftUI

struct SmallCardView: View {
    let string: LocalizedStringKey

    var body: some View {
        Text(string)
            .font(.headline)
            .foregroundColor(.white)
            .padding(10)
            .background(.purple)
            .cornerRadius(5)
            .shadow(radius: 8)
    }
}
