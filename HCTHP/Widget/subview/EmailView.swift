//
//  EmailView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct EmailView: View {
    
    @Binding var email: String
    @FocusState var focusedField: RegistrationFields?
    @EnvironmentObject var authVM: AuthVM

    var body: some View {
        TextInputField("Email", text: $email)
            .submitLabel(.next)
            .clearButtonHidden()
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .focused($focusedField, equals: .email)
            .onValidate{ email in
                return authVM.validateEmail(email)
            }
            .onSubmit {
                focusedField = .password
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
    }
}
