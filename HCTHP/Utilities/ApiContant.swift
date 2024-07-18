//
//  ApiContant.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-15.
//

import Foundation

struct ApiContant {

    static let basePublicUrl = "http://127.0.0.1:8000/api" //"https://hcthp.premiercode.pro/api"
    static let baseUrl = "\(basePublicUrl)/v1"

    static let deleteUserSavedDrugsWithId = "http://hcthp.premiercode.pro/api/v1/drugs/{id}"
}
