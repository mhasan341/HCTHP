//
//  LoginView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import SwiftUI

struct LoginView: View {
    // these will hold the values we'll send to server
    @State private var email: String = ""
    @State private var password: String = ""

    // for our custom secure field
    @State private var isSecure: Bool = true

    // to move to next textfield
    @FocusState private var focusedField: RegistrationFields?

    var body: some View {
        // We'll add navigation later
        VStack {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.accent)
                .padding(.top, 30)

            VStack(alignment: .leading, spacing: 20) {


                TextInputField("Email", text: $email)
                    .submitLabel(.next)
                    .clearButtonHidden()
                    .focused($focusedField, equals: .email)
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

                // Not using the system SecureField as we need the floating behavior
                TextInputField("Password", text: $password)
                    .clearButtonHidden()
                    .submitLabel(.go)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        //call the registration function here
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
            .padding(.horizontal, 20)
            .padding(.top, 40)

            Spacer()

            Button(action: {
                // Call the VM here
            }) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
            }



        } // VStack
        .navigationBarBackButtonHidden()

    } // body
}

#Preview {
    LoginView()
}
