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

struct SignupErrors: Codable {
    let name: [String]?
    let email: [String]?
    let password: [String]?

    func allErrors() -> [String] {
        var allErrors: [String] = []
        if let nameErrors = name {
            allErrors.append(contentsOf: nameErrors)
        }
        if let emailErrors = email {
            allErrors.append(contentsOf: emailErrors)
        }
        if let passwordErrors = password {
            allErrors.append(contentsOf: passwordErrors)
        }
        return allErrors
    }
}
