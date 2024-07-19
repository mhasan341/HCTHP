//
//  HCActionButton.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

/// Takes a title, a binding that control whether the button should be disabled or not and background color
struct HCActionButton: View {
    
    var buttonTitle: String
    @Binding var shouldDisableButton: Bool

    var onTap: ()->Void?

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text(buttonTitle)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(shouldDisableButton ? .gray : .blue)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.top, 40)
        }
        .disabled(shouldDisableButton)
    }
}
