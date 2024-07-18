//
//  SearchMedication.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-18.
//

import SwiftUI

struct SearchMedication: View {
    @StateObject private var drugVM = DrugVM()
    @State private var searchQuery: String = ""

    var body: some View {
        List(drugVM.searchResult) { item in
            MedicationItem(medineName: item.name)
        }
        .refreshable {
            searchDB()
        }
        .navigationTitle("My Medications")
        .searchable(text: $searchQuery, placement: .toolbar, prompt: "Search drugs")
        .onSubmit(of: .search) {
            searchDB()
        }
    }
    
    private func searchDB(){
        Task {
            await drugVM.searchDrugs(by: searchQuery)
        }
    }

}

#Preview {
    SearchMedication()
}
