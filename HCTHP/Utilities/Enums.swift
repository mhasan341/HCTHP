//
//  Enums.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-15.
//

import Foundation

/// to be used for focus
enum RegistrationFields {
    case name
    case email
    case password
}

/// different errors used in this app
public enum ValidationError: Error, Identifiable {
    case nameRequired
    case nameTooShort
    case nameTooLong

    case emailRequired
    case emailInvalid

    case passwordRequired
    case passwordTooShort

    // for server releated
    case serverError
    case clientError

    public var id: String {
        return self.localizedDescription
    }

    var localizedDescription: String {
        switch self {
            case .nameRequired:
                return "Name is required."
            case .nameTooShort:
                return "Name must be at least 3 characters long."
            case .nameTooLong:
                return "Name must be less than 256 characters long."
            case .emailRequired:
                return "Email is required."
            case .emailInvalid:
                return "Email is not valid."
            case .passwordRequired:
                return "Password is required."
            case .passwordTooShort:
                return "Password must be at least 8 characters long."
            case .serverError:
                return "Server returned an error"
            case .clientError:
                return "Please Check your input again"
        }
    }
}

enum Keys {
    static let AUTH_TOKEN = "token"
    static let GENERIC_ERROR = "An error occured"
}
