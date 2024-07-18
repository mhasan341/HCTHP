//
//  Drug.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import Foundation

struct Drug: Codable, Identifiable {
    var id: String {
        return rxcui
    }
    let rxcui: String
    let name: String
    let synonym: String
    let language: String
    let psn: String
}
