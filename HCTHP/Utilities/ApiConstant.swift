//
//  ApiContant.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-15.
//

import Foundation

struct ApiConstant {
    //MARK: Base urls
    /// feturns the public api path in server
    static let basePublicUrl = "http://127.0.0.1:8000/api" //"https://hcthp.premiercode.pro/api"
    /// returns the private api path in server, protected by sanctum
    static let baseUrl = "\(basePublicUrl)/v1"

    //MARK: Auth urls
    /// POST: register a user using the values provided
    static let registrationUrl = "\(basePublicUrl)/register"
    /// POST: log in a user using the credentials provided
    static let loginUrl = "\(basePublicUrl)/login"

    //MARK: Medications related
    /// GET | Public: search a drug using the term provided "drug_name",
    static let medicationSearchUrl = "\(basePublicUrl)/drugs/search?drug_name="

    /// DELETE | Private: delete a saved drug for a user in server. parameter "rxcui" in x-www-form-urlencoded data
    static let deleteUserSavedDrugsWithId = "\(baseUrl)/userDrug/delete"
    /// GET | Private: returns all medications that are saved by this user
    static let getMedicationsOfUserUrl = "\(baseUrl)/getDrugs/byUser"
    /// POST: Private: saves a medication is user's medication list in server. takes a parameter "rxcui" in form data
    static let saveMedicationToUserUrl = "\(baseUrl)/drugs/save"

}
