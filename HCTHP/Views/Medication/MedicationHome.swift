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
    @State private var isAlertPresent = false

    var body: some View {
        NavigationStack {
            VStack {
                if !drugVM.isLoading && !drugVM.savedDrugs.isEmpty {
                    List(drugVM.savedDrugs ) { item in
                        MedicationItem(medineName: item.name)
                            .swipeActions(edge: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/, allowsFullSwipe: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                                Button("Delete"){
                                    Task {
                                        await drugVM.deleteDrug(drugId: item.id)
                                    }
                                }
                            }.tint(.red)
                    }

                } else {
                        ContentUnavailableView("You don't have any medications to show", image: "drug_icon", description: nil)
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
        .onChange(of: drugVM.medicationDeleteMessage, { oldValue, newValue in
            if !newValue.isEmpty {
                isAlertPresent = true
            }
        })
        .alert(drugVM.medicationDeleteMessage, isPresented: $isAlertPresent) {
            Button {
                isAlertPresent.toggle()
            } label: {
                Text("Dismiss")
            }
        }
        .onAppear {
            Task {
                await drugVM.getUserDrugs()
            }
        }

    }

    
}
