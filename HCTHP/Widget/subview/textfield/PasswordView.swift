//
//  PasswordView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct PasswordView: View {
    
    @Binding var password: String
    @FocusState var focusedField: RegistrationFields?
    @EnvironmentObject var authVM: AuthVM

    // for our custom secure field
    @State private var isSecure: Bool = true

    var onTap: ()->Void?

    var body: some View {
        // Not using the system SecureField as we need the floating behavior
        TextInputField("Create a password", text: $password)
            .clearButtonHidden()
            .submitLabel(.go)
            .focused($focusedField, equals: .password)
            .onValidate{ password in
                return authVM.validatePassword(password)
            }
            .onSubmit {
                // since it's the last view on both auth views, we want to pass the event to the root view
                onTap()
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
