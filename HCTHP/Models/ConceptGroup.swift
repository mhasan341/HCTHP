//
//  ConceptGroup.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import Foundation

struct ConceptGroup: Codable {
    let tty: String
    let conceptProperties: [ConceptProperty]?
}
