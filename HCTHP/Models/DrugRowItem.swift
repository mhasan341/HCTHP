//
//  DrugSearchItem.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-18.
//

import Foundation

struct DrugRowItem: Codable, Identifiable {
    var id: String {
        return rxcui
    }
    let rxcui: String
    let name: String
}
