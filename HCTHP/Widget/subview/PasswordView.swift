//
//  PasswordView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct PasswordView: View {
    
    @Binding var email: String
    @FocusState var focusedField: RegistrationFields?
    @EnvironmentObject var authVM: AuthVM
    
    var body: some View {
        // Not using the system SecureField as we need the floating behavior
        TextInputField("Create a password", text: $password)
            .clearButtonHidden()
            .submitLabel(.go)
            .focused($focusedField, equals: .password)
            .onSubmit {
                doRegistration()
            }
            .setTextFieldSecure(isSecure)
            .textContentType(.password)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .overlay(
                HStack {
                    Spacer()
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: self.isSecure ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }
            )
    }
}

#Preview {
    PasswordView()
}
