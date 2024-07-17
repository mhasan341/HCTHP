//
//  RegistrationView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import SwiftUI
import IQKeyboardManagerSwift
import Combine

struct RegistrationView: View {
    @EnvironmentObject var authVM: AuthVM

    // these will hold the values we'll send to server
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    @State private var emailError = ""
    @State private var isAlertShowing = false


    // to move to next textfield
    @FocusState private var focusedField: RegistrationFields?


    var body: some View {
        // We'll add navigation later
        VStack {
            Text("Create New Account")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.accent)
                .padding(.top, 30)

            VStack(alignment: .leading, spacing: 20) {

                // for the name input
                NameView(name: $name, focusedField: _focusedField)
                // for the email input
                EmailView(email: $email, focusedField: _focusedField)
                // for the password input
                PasswordView(password: $password, focusedField: _focusedField) {
                    doRegistration()
                }

            }
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
            HCActionButton(buttonTitle: "Create Account") {
                // The validation for name, email and password will show the errors where required
                // But we need to control the action button
                doRegistration()
            }
            .disabled(authVM.shouldDisableRegistrationButton())



        } // VStack
        .navigationBarBackButtonHidden()
        // To track errors
        .onChange(of: authVM.detailedErrors) { oldValue, newValue in
            self.emailError = newValue["email", default: ""]
            self.isAlertShowing = true
        }
        .onAppear {
            // resetting it for a new session in case previous data present
            authVM.detailedErrors = [:]
        }
        // to show any alert related to email that came from server
        .alert(self.emailError, isPresented: $isAlertShowing) {
            Button {
                isAlertShowing.toggle()
            } label: {
                Text("Dismiss")
            }

        }


    } // body

    private func doRegistration() {
        // hide the keyboard if present
        IQKeyboardManager.shared.resignFirstResponder()

        // The validation for name, email and password will show the errors where required
        // But we need to control the action button

        // calls the authVM
        Task {
            await authVM.signUp(name: name, email: email, password: password)
        }

    }

    
}
