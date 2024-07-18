//
//  DrugSearchItem.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-18.
//

import Foundation

struct DrugRowItem: Codable {
    let status: Bool
    let message: String
    let data: [DrugRowData]?
}

struct DrugRowData: Codable, Identifiable {
    var id: String {
        return rxcui
    }
    let rxcui: String
    let name: String
}
