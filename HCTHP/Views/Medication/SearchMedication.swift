//
//  SearchMedication.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-18.
//

import SwiftUI

struct SearchMedication: View {
    // view model that manages the backend calls and publishes result or error
    // we're not using environmentObject because we want this view to own this VM
    @StateObject private var drugVM = DrugVM()
    // the query user entered in the searchbox, we use this to search on backend
    @State private var searchQuery: String = ""
    // binding from MedicationHome that closes the search view, as we are presenting it as sheet
    @Binding var sheetShowing: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                if let searchResult = drugVM.searchResult, let resultData = searchResult.data {
                    List(resultData) { item in
                        NavigationLink {
                            MedicationDetail(drugId: item.rxcui)
                                .environmentObject(drugVM)
                        } label: {
                            MedicationItem(medineName: item.name)
                        }
                    }
                }
                // this view looks better with system image
                if let error = drugVM.errorMessage, !error.isEmpty {
                    // to make the pull to refresh work we need a scroll view
                    ScrollView {
                        // scrollView tightens view, so we want to put some space
                        Spacer(minLength: 200)
                        ContentUnavailableView("Sorry!", systemImage: "pills.circle", description: Text(error))
                    }
                }
            }
            // by default sheets are dragged down to dismiss
            // so adding a back button to match the figma design
            .toolbar {
                toolbarBackButton()
            }
            .navigationTitle("Search Medications")
            // as per the design, we want it inline
            .navigationBarTitleDisplayMode(.inline)
        }
        // on pull to refresh we want to call the backend again
        .refreshable {
            searchDB()
        }
        // adds a searchbar on the view, adds "Search" button on keyboard
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Medications")
        // on return key pressed the actual search happends
        .onSubmit(of: .search) {
            searchDB()
        }
    }
    
    // searches the backend and published the result that we use above
    private func searchDB(){
        Task {
            await drugVM.searchDrugs(by: searchQuery)
        }
    }

    // to make the layout cleaner, extracted method
    // extracted variable works, but it can't call the 'sheetShowing' variables are initialized before self is available.
    fileprivate func toolbarBackButton() -> ToolbarItem<(), some View> {
        return ToolbarItem (placement: .topBarLeading) {
            Label("Back", systemImage: "chevron.backward")
                .labelStyle(.titleAndIcon)
                .foregroundStyle(.accent)
                .onTapGesture {
                    sheetShowing = false
                }
        }
    }


}
