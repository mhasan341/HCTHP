//
//  DrugSearchItem.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-18.
//

import Foundation

/// status, message and an array of [drug name and rxcui], array is optional
struct DrugRowItem: Codable {
    let status: Bool
    let message: String?
    let data: [DrugRowData]?
}

// drug name and rxcui
struct DrugRowData: Codable, Identifiable, Equatable {
    var id: String {
        return rxcui
    }
    let rxcui: String
    let name: String
}
