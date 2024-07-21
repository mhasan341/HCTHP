//
//  DrugDetail.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-19.
//

import Foundation

/// status, message and an optional Drug object, that holds the entire information we have about it
class DrugDetail: Codable {
    let status: Bool
    let message: String
    var data: Drug?
}
