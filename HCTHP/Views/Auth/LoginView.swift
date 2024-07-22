//
//  LoginView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import SwiftUI
import IQKeyboardManagerSwift

struct LoginView: View {
    @EnvironmentObject private var authVM: AuthVM

    // these will hold the values we'll send to server
    @State private var email: String = ""
    @State private var password: String = ""

    // for our custom secure field
    @State private var isSecure: Bool = true

    // to move to next textfield
    @FocusState private var focusedField: RegistrationFields?

    // to show custom error
    @State private var isAlertShowing = false

    var body: some View {
        // We'll add navigation later
        VStack {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.accent)
                .padding(.top, 30)

            VStack(alignment: .leading, spacing: 20) {

                // for the email input
                EmailView(email: $email, focusedField: _focusedField)
                // for the password input
                PasswordView(password: $password, focusedField: _focusedField) {
                    if !authVM.shouldDisableLoginButton {
                        login()
                    }
                }

            } // VStack
            .padding(.horizontal, 20)
            .padding(.top, 40)

            // show the loading view based on status
            if authVM.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                    .padding(.top, 20)
            }

            Spacer()

            // the action button
            HCActionButton(buttonTitle: "Log In", shouldDisableButton: $authVM.shouldDisableLoginButton) {
                // The validation for name, email and password will show the errors where required
                // But we need to control the action button
                login()
            }
            .padding(.bottom, 20)
             // mahmud@housecall.ae
            // password
        } // VStack Main
        .navigationBarBackButtonHidden()
        // To track errors
        .onChange(of: authVM.loginError) {newValue in

            if let newValue = newValue, !newValue.isEmpty {
                self.isAlertShowing = true
            }


        }
        // to show any alert related to email that came from server
        .alert(authVM.loginError ?? Keys.GENERIC_ERROR, isPresented: $isAlertShowing) {
            Button {
                authVM.loginError = ""
                isAlertShowing.toggle()
            } label: {
                Text("Dismiss")
            }
        }
        .onAppear {
            authVM.setupValidations()
        }
    }


            /// validates then takes the call to ViewModel
            private func login(){
                // hide the keyboard if present
                IQKeyboardManager.shared.resignFirstResponder()

                Task {
                    await authVM.login(email: email, password: password)
                }
            }
}

