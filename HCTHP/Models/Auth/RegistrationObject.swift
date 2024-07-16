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
    let errors: SignupErrors?
}

struct SignupErrors: Codable {
    let name: [String]?
    let email: [String]?
    let password: [String]?
}
