//
//  LoginObject.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-15.
//

import Foundation

/// Stores information returned from server
struct LoginObject: Codable {
    let status: Bool
    let message: String
    let accessToken: String

    // We could've used keyDecodingStrategy as well
    enum CodingKeys: String, CodingKey {
        case status
        case accessToken = "access_token"
        case message
    }
}
