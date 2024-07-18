//
//  HCActionButton.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct HCActionButton: View {
    
    var buttonTitle: String
    var onTap: ()->Void?

    @EnvironmentObject var authVM: AuthVM

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text(buttonTitle)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(authVM.shouldDisableLoginButton() ? .gray : .blue)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.top, 40)
        }
    }
}
