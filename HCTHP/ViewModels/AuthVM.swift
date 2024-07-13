//
//  AuthVM.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import Foundation
import Combine

class AuthVM: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func signUp() {
        // Updating soon
    }

    func login() {
        // Updating soon
    }
}
