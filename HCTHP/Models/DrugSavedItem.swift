//
//  DrugSavedItem.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-18.
//

import Foundation

/// status and an array of [drug name and rxcui]
class DrugSavedItem: Codable {
    let status: Bool
    var data: [DrugRowData]
}
