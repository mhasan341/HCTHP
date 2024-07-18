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
    @Binding var sheetShowing: Bool

    var body: some View {
        NavigationStack {
            if let searchResult = drugVM.searchResult, let resultData = searchResult.data {
                List(resultData) { item in
                    MedicationItem(medineName: item.name)
                }
                .toolbar {
                    ToolbarItem (placement: .topBarLeading) {
                        Label("Back", systemImage: "chevron.backward")
                            .labelStyle(.titleAndIcon)
                            .foregroundStyle(.accent)
                            .onTapGesture {
                                sheetShowing = false
                            }
                    }
                }
            }


            if let error = drugVM.errorMessage, !error.isEmpty {
                ContentUnavailableView("Opps!" , image: "drug_icon", description: Text(error))
            }
        }

        .refreshable {
            searchDB()
        }
        .searchable(text: $searchQuery, placement: .toolbar, prompt: "Search drugs")
        .onSubmit(of: .search) {
            searchDB()
        }
        .onChange(of: drugVM.errorMessage, { oldValue, newValue in
            if let newValue = newValue, !newValue.isEmpty {

            }
        })
        .navigationTitle("Search Medications")


    }
    
    private func searchDB(){
        Task {
            await drugVM.searchDrugs(by: searchQuery)
        }
    }

}
