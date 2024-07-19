//
//  NameView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

/// TextField used in auth pages with validation, focus changing options
struct NameView: View {

    @Binding var name: String
    @FocusState var focusedField: RegistrationFields?
    @EnvironmentObject var authVM: AuthVM


    var body: some View {
        TextInputField("Name", text: $name)
            .submitLabel(.next)
            .clearButtonHidden()
            .focused($focusedField, equals: .name)
            .onValidate{ name in
                return authVM.validateName(name)
            }
            .onSubmit {
                focusedField = .email
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
