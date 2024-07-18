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
            VStack {
                if let searchResult = drugVM.searchResult, let resultData = searchResult.data {
                    List(resultData) { item in
                        MedicationItem(medineName: item.name)
                    }
                }

                if let error = drugVM.errorMessage, !error.isEmpty {
                    ContentUnavailableView("Opps!" , image: "drug_icon", description: Text(error))
                }
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
            .navigationTitle("Search Medications")
            .navigationBarTitleDisplayMode(.inline)
        }
        .refreshable {
            searchDB()
        }
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Medications")
        .onSubmit(of: .search) {
            searchDB()
        }
        .onChange(of: drugVM.errorMessage, { oldValue, newValue in
            if let newValue = newValue, !newValue.isEmpty {

            }
        })
    }
    
    private func searchDB(){
        Task {
            await drugVM.searchDrugs(by: searchQuery)
        }
    }

}
