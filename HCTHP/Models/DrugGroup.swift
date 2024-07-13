//
//  DrugGroup.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import Foundation

struct DrugGroup: Codable {
    let name: String?
    let conceptGroup: [ConceptGroup]
}
