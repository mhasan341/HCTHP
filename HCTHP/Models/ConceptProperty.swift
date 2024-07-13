//
//  ConceptProperty.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import Foundation

struct ConceptProperty: Codable, Identifiable {
    var id: String {
        return rxcui
    }
    let rxcui: String
    let name: String
    let synonym: String
    let tty: String
    let language: String
    let suppress: String
    let umlscui: String
}
