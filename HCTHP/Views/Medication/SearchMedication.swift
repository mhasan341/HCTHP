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
            List(drugVM.searchResult) { item in
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

        .refreshable {
            searchDB()
        }
        .searchable(text: $searchQuery, placement: .toolbar, prompt: "Search drugs")
        .onSubmit(of: .search) {
            searchDB()
        }
        .navigationTitle("Search Medications")


    }
    
    private func searchDB(){
        Task {
            await drugVM.searchDrugs(by: searchQuery)
        }
    }

}
