//
//  MedicationHome.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct MedicationHome: View {
    @StateObject private var drugVM = DrugVM()
    @State private var isSearchViewPresent = false

    var body: some View {
        NavigationStack {
            VStack {
                if let userDrugs = drugVM.savedDrugs {
                        List(userDrugs.data) { item in
                            MedicationItem(medineName: item.name)
                        }

                } else{
                        ContentUnavailableView("Sorry we couldn't find any saved drug", image: "drug_icon", description: nil)
                }

               // Spacer()
                SearchMedicationButton {
                    isSearchViewPresent = true
                }
            }

            .refreshable {
                Task {
                    await drugVM.getUserDrugs()
                }

            }
            .navigationTitle("My Medications")

        }
        .sheet(isPresented: $isSearchViewPresent) {
            SearchMedication(sheetShowing: $isSearchViewPresent)
        }
        .onAppear {
            Task {
                await drugVM.getUserDrugs()
            }
        }

    }

    
}
