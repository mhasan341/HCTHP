//
//  AuthVM.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import Foundation
import Combine

class AuthVM: ObservableObject {

    // Error releated to signup and login will be published here
    @Published var loginError: String?
    @Published var signupError: String?

    private var cancellables = Set<AnyCancellable>()

    /// Creates an account for the user in the backend using combine framework
    func signUp(name: String, email: String, password: String) {
        print("Signing up")
        guard let url = URL(string: "\(ApiContant.baseURL)/register") else {
            self.signupError = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["name": name, "email": email, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            self.signupError = "Invalid request body"
            return
        }
        request.httpBody = bodyData

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: RegistrationObject.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        self.signupError = error.localizedDescription
                        print(error.localizedDescription)
                    case .finished:
                        print("Success")
                        break
                }
            }, receiveValue: { response in
                self.signupError = nil
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

                // Create the URL request
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                // Create the request body
                let body: [String: String] = ["email": email, "password": password]
                guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
                    self.loginError = "Invalid request body"
                    return
                }
                request.httpBody = bodyData

                // Perform the network request
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(LoginObject.self, from: data)

                #warning("Use the response")

                print("Login successful: \(response)")
                DispatchQueue.main.async {
                    self.loginError = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginError = error.localizedDescription
                }
            }
        }

}
