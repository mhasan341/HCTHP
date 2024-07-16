//
//  RegistrationObject.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-16.
//

import Foundation

struct RegistrationObject: Codable {
    let status: Bool
    let message: String
    let access_token: String?
    let errors: SignupErrors?
}

// We're validating name and password on client side, so skipping that part
struct SignupErrors: Codable {
    let email: [String]?

    func allErrors() -> [String: String] {
        var allErrors: [String: String] = [:]
        if let errors = email, let emailError = errors.first {
            allErrors["email"] = emailError
        }
        return allErrors
    }
}
