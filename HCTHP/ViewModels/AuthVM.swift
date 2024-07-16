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

    // Error releated to signup and login will be published here
    @Published var loginError: String?
    @Published var signupError: String?
    // this will store multiple errors if there are any
    @Published var detailedErrors: [String] = []

    // to store the combine cancellables
    private var cancellables = Set<AnyCancellable>()

    /// Creates an account for the user in the backend using combine framework
    func signUp(name: String, email: String, password: String) {

        // From RegistrationView, we'd make sure that the name, email and password is valid already
        // So we're not checking that here
        guard let url = URL(string: "\(ApiContant.baseURL)/register") else {
            // we don't need to throw an error here
            return
        }

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
                    case .failure(let error):
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
                    self.signupError = nil
                    self.detailedErrors = []
                } else {
                    self.signupError = response.message
                    // not everytime there will be a list of errors
                    if let errors = response.errors {
                        self.detailedErrors = errors.allErrors()
                    } else {
                        self.detailedErrors = []
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

}
