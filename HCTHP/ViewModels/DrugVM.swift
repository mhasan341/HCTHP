//
//  DrugVM.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import Foundation
import Combine

class DrugVM: ObservableObject {
    @Published var drugs: [DrugGroup] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func searchDrugs(by name: String) {

    }

    func addDrug(rxcui: String) {

    }

    func getUserDrugs() {

    }

    func deleteDrug(drugId: String) {

    }
}
