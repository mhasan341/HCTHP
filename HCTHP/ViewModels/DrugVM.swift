//
//  DrugVM.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import SwiftUI
import Combine

class DrugVM: ObservableObject {

    @AppStorage(Keys.AUTH_TOKEN) var authToken: String = ""

    @Published var isLoading = false
    @Published var searchResult: DrugRowItem?
    @Published var savedDrugs: DrugSavedItem?

    @Published var errorMessage: String?

    /// searchs the database using the given query
    func searchDrugs(by name: String) async {
        do {
            // From RegistrationView, we'd make sure that the name, email and password is valid already
            // So we're not checking that here
            guard let url = URL(string: "\(ApiContant.basePublicUrl)/drugs/search?drug_name=\(name)") else {
                // we don't need to throw an error here
                return
            }

            // since our data is already sanitized, we'd want the loader to show now
            DispatchQueue.main.async {
                self.isLoading = true
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Perform the network request
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(DrugRowItem.self, from: data)

            print(response)

            DispatchQueue.main.async {
                self.isLoading = false
                if response.status {
                    // success here
                    self.searchResult = response
                } else {
                    self.errorMessage = response.message
                }

            }
        } catch(let error) {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func addDrug(rxcui: String) {

    }

    func getUserDrugs() async {
        do {
            // From RegistrationView, we'd make sure that the name, email and password is valid already
            // So we're not checking that here
            guard let url = URL(string: "\(ApiContant.baseUrl)/getDrugs/byUser") else {
                // we don't need to throw an error here
                return
            }

            // since our data is already sanitized, we'd want the loader to show now
            DispatchQueue.main.async {
                self.isLoading = true
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

            // Perform the network request
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(DrugSavedItem.self, from: data)

            DispatchQueue.main.async {
                // success here
                self.isLoading = false
                self.savedDrugs = response

            }
        } catch(let error) {
            DispatchQueue.main.async {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }

    func deleteDrug(drugId: String) {

    }
}
