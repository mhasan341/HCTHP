//
//  AuthVM.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import Foundation
import Combine

class AuthVM: ObservableObject {

    /// Indicates if the request to server is running or returned and stopped
    @Published var isLoading = false

    /// Error releated to signup and login will be published here
    @Published var loginError: String?

    /// errors during registration process will be emitted
    @Published var detailedErrors: [String: String] = [:]

    // to store the combine cancellables
    private var cancellables = Set<AnyCancellable>()

    /// Emits the name string that needs to be validated.
    private let nameSubject = PassthroughSubject<String, Never>()
    /// Emits the email that needs to be validated
    private let emailSubject = PassthroughSubject<String, Never>()

    /// Published to update the view with the latest validation result.
    @Published var nameValidationResult: Result<Bool, ValidationError>?
    @Published var emailValidationResult: Result<Bool, ValidationError>?

    init() {
        setupValidations()
    }


    /// Creates an account for the user in the backend using combine framework
    func signUp(name: String, email: String, password: String) {

        // From RegistrationView, we'd make sure that the name, email and password is valid already
        // So we're not checking that here
        guard let url = URL(string: "\(ApiContant.baseURL)/register") else {
            // we don't need to throw an error here
            return
        }

        // since our data is already sanitized, we'd want the loader to show now
        isLoading = true

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["name": name, "email": email, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            // we don't need to throw an error here
            self.isLoading = false
            return
        }
        request.httpBody = bodyData

        // start the process
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }

                return output.data
            }
            .decode(type: RegistrationObject.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // stop the flag
                self.isLoading = false
                switch completion {
                    case .failure(_):
                        print("Failure")
                    case .finished:
                        print("Success")
                        break
                }
            }, receiveValue: { response in
                // to make sure the loading is stopped
                self.isLoading = false
                // if the user could register we have the token
                if response.status {
                    #warning("Use the token now")
                    self.detailedErrors = [:]
                } else {
                    // not everytime there will be a list of errors
                    if let errors = response.errors {
                        self.detailedErrors = errors.allErrors()
                    } else {
                        self.detailedErrors = [:]
                    }
                }
            })
            .store(in: &self.cancellables)

    }

    /// calls the backend using modern swift concurrency to login the user
    func login(email: String, password: String) async {

            do {
                // Create the URL
                guard let url = URL(string: "\(ApiContant.baseURL)/login") else {
                    self.loginError = "Invalid URL"
                    return
                }

                isLoading = true

                // Create the URL request
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                // Create the request body
                let body: [String: String] = ["email": email, "password": password]
                guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
                    self.loginError = "Invalid request body"
                    isLoading = false
                    return
                }
                request.httpBody = bodyData

                // Perform the network request
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(LoginObject.self, from: data)

                #warning("Use the response")

                DispatchQueue.main.async {
                    self.isLoading = false
                    self.loginError = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.loginError = error.localizedDescription
                }
            }
        }

    //MARK: Name Validation
    // setting up the validation process of name field using Combine
    private func setupValidations() {
        nameSubject
            .dropFirst() // to prevent error from showing when user just opened the screen
            .sink { [weak self] name in
                guard let self = self else { return }
                self.nameValidationResult = self.validateNameConditions(name)
            }
            .store(in: &cancellables)

        emailSubject
            .dropFirst() // Skip the first emitted value for email
            .sink { [weak self] email in
                guard let self = self else { return }
                self.emailValidationResult = self.validateEmailConditions(email)
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
            return .failure(ValidationError(message: "Name is required"))
        } else if name.count < 3 {
            return .failure(ValidationError(message: "Name must be at least 3 characters long"))
        } else if name.count > 255 {
            return .failure(ValidationError(message: "Name must be less than 256 characters long"))
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
            return .failure(ValidationError(message: "Email is required"))
        } else if !isValidEmail(email) {
            return .failure(ValidationError(message: "Email is not valid"))
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
}

