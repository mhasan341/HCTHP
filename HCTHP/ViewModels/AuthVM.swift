//
//  AuthVM.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import SwiftUI
import Combine

class AuthVM: ObservableObject {
    @AppStorage(Keys.AUTH_TOKEN) var authToken: String = ""
    /// Determines whether or not current user is logged in
    @Published var isLoggedIn = false
    /// Indicates if the request to server is running or returned and stopped
    @Published var isLoading = false

    /// Error releated to login will be published here
    @Published var loginError: String?

    /// Error releated to registration will be published here
    @Published var registrationError: String?

    /// errors during registration process will be emitted
    @Published var detailedErrors: [String: String] = [:]

    // to store the combine cancellables
    private var cancellables = Set<AnyCancellable>()

    /// Emits the name string that needs to be validated.
    private let nameSubject = PassthroughSubject<String, Never>()
    /// Emits the email that needs to be validated
    private let emailSubject = PassthroughSubject<String, Never>()
    /// Emits the password that needs to be validated
    private let passwordSubject = PassthroughSubject<String, Never>()

    /// Published to update the view with the latest validation result.
    @Published var nameValidationResult: Result<Bool, ValidationError>?
    @Published var emailValidationResult: Result<Bool, ValidationError>?
    @Published var passwordValidationResult: Result<Bool, ValidationError>?

    @Published var shouldDisableLoginButton: Bool = true
    @Published var shouldDisableRegistrationButton: Bool = true

    init() {
        setupValidations()
    }


    /// Creates an account for the user in the backend
    func signUp(name: String, email: String, password: String) async {

        do {
        // From RegistrationView, we'd make sure that the name, email and password is valid already
        // So we're not checking that here
        guard let url = URL(string: ApiConstant.registrationUrl) else {
            // we don't need to throw an error here
            return
        }

        // since our data is already sanitized, we'd want the loader to show now
        DispatchQueue.main.async {
            self.isLoading = true
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["name": name, "email": email, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async {
                self.registrationError = ValidationError.clientError.localizedDescription
                self.isLoading = false
            }
            return
        }
        request.httpBody = bodyData


        // Perform the network request
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(RegistrationObject.self, from: data)

        DispatchQueue.main.async {

                self.isLoading = false
                self.registrationError = nil
                guard let token = response.access_token else {return}
                self.authToken = token
                self.isLoggedIn = true


        }
    } catch {
        DispatchQueue.main.async {
            self.isLoading = false
            self.registrationError = error.localizedDescription
        }
    }

    }

    /// calls the backend using modern swift concurrency to login the user
    func login(email: String, password: String) async {

            do {
                // Create the URL
                guard let url = URL(string: ApiConstant.loginUrl) else {
                    return
                }

                DispatchQueue.main.async {
                    self.isLoading = true
                }

                // Create the URL request
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                // Create the request body
                let body: [String: String] = ["email": email, "password": password]
                guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
                    DispatchQueue.main.async {
                        self.loginError = ValidationError.clientError.localizedDescription
                        self.isLoading = false
                    }
                    return
                }
                request.httpBody = bodyData

                // Perform the network request
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(LoginObject.self, from: data)

                DispatchQueue.main.async {

                    if response.status {
                        self.isLoading = false
                        self.loginError = nil
                        guard let token = response.accessToken else {return}
                        self.authToken = token
                        self.isLoggedIn = true
                    } else {
                        self.isLoading = false
                        self.loginError = response.message
                        self.isLoggedIn = false
                    }

                }
            } catch {
                DispatchQueue.main.async {
                    print("Error Catched")
                    self.isLoading = false
                    self.loginError = error.localizedDescription
                }
            }
        }

    //MARK: Name Validation
    // setting up the validation process of name field using Combine
    private func setupValidations() {
        // Publisher for name
        nameSubject
            .dropFirst() // to prevent error from showing when user just opened the screen
            .sink { [weak self] name in
                guard let self = self else { return }
                self.nameValidationResult = self.validateNameConditions(name)
                self.shouldDisableRegistrationButton =  checkRegistrationButtonDisabled()
            }
            .store(in: &cancellables)

        // Publisher for email
        emailSubject
            .dropFirst() // Skip the first emitted value for email
            .sink { [weak self] email in
                guard let self = self else { return }
                self.emailValidationResult = self.validateEmailConditions(email)

                self.shouldDisableRegistrationButton =  checkRegistrationButtonDisabled()

                self.shouldDisableLoginButton = checkLoginButtonDisabled()
            }
            .store(in: &cancellables)

        // Publisher for password
        passwordSubject
            .dropFirst() // Skip the first emitted value for email
            .sink { [weak self] password in
                guard let self = self else { return }
                self.passwordValidationResult = self.validatePasswordConditions(password)

                self.shouldDisableRegistrationButton =  checkRegistrationButtonDisabled()

                self.shouldDisableLoginButton = checkLoginButtonDisabled()

            }
            .store(in: &cancellables)


    }

    /// Validates name and returns the result
    func validateName(_ name: String) -> Result<Bool, ValidationError> {
        nameSubject.send(name)
        return nameValidationResult ?? .success(true)
    }

    /// takes a name and runs our predefined conditions on it
    private func validateNameConditions(_ name: String) -> Result<Bool, ValidationError> {
        if name.isEmpty {
            return .failure(.nameRequired)
        } else if name.count < 3 {
            return .failure(.nameTooShort)
        } else if name.count > 255 {
            return .failure(.nameTooLong)
        } else {
            return .success(true)
        }
    }


    //MARK: Email Validation

    /// validates the email and returns the result
    func validateEmail(_ email: String) -> Result<Bool, ValidationError> {
        emailSubject.send(email)
        return emailValidationResult ?? .success(true)
    }

    /// takes an emal and runs our predefined conditions on it
    private func validateEmailConditions(_ email: String) -> Result<Bool, ValidationError> {
        if email.isEmpty {
            return .failure(.emailRequired)
        } else if !isValidEmail(email) {
            return .failure(.emailInvalid)
        } else {
            return .success(true)
        }
    }

    /// Returns if the supplied email is valid
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }


    //MARK: Password Validation

    /// validates the password and returns the result
    func validatePassword(_ password: String) -> Result<Bool, ValidationError> {
        passwordSubject.send(password)
        return passwordValidationResult ?? .success(true)
    }

    /// takes a password and runs our predefined conditions on it
    private func validatePasswordConditions(_ password: String)-> Result<Bool, ValidationError> {
        if password.isEmpty {
            return .failure(.passwordRequired)
        } else if password.count < 8 {
            return .failure(.passwordTooShort)
        } else {
            return .success(true)
        }
    }

    //MARK: For action button

    /// returns if all input fields in registration view is valid
    private func checkRegistrationButtonDisabled()->Bool{
        if case .success(let nameIsValid) = nameValidationResult, nameIsValid,
           case .success(let emailIsValid) = emailValidationResult, emailIsValid,
           case .success(let passwordIsValid) = passwordValidationResult, passwordIsValid {
            return false
        } else {
            return true
        }
    }

    /// returns if all input fields in login view is valid
    private func checkLoginButtonDisabled()->Bool {
        if case .success(let emailIsValid) = emailValidationResult, emailIsValid,
           case .success(let passwordIsValid) = passwordValidationResult, passwordIsValid {
            return false
        } else {
            return true
        }
    }

    /// used to logout user from the app
    func logout(){
        isLoggedIn = false
        self.authToken = ""
    }






}

