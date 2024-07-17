//
//  DrugDetail.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import Foundation

public struct DrugDetail: Codable {
   var drugGroup: DrugGroup
}

struct DrugGroup: Codable {
    let name: String?
    let conceptGroup: [ConceptGroup]
}

struct ConceptGroup: Codable {
    let tty: String
    let conceptProperties: [ConceptProperty]?
}
