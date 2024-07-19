//
//  MedicationHome.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI
import EventKit
import EventKitUI

struct MedicationHome: View {
    @StateObject private var drugVM = DrugVM()

    @State private var isSearchViewPresent = false
    @State private var isAlertPresent = false
    @State private var isReminderPresent = false

    let store = EKEventStore(sources: .init())

    var body: some View {
        NavigationStack {
            VStack {
                if !drugVM.isLoading && !drugVM.savedDrugs.isEmpty {
                    List(drugVM.savedDrugs ) { item in

                        MedicationItem(medineName: item.name)
                        // delete on left swipe
                            .swipeActions(edge: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/, allowsFullSwipe: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                                Button("Delete"){
                                    Task {
                                        await drugVM.deleteDrug(drugId: item.id)
                                    }
                                }
                            }.tint(.red)
                        // add reminder on right swipe
                            .swipeActions(edge: .leading, allowsFullSwipe: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                                // this one adds a reminder
                                // in real case we could do lots of customization
                                Button {
                                    
                                    store.requestFullAccessToReminders { isGranted, errors in
                                        print("Reminder Granted? \(isGranted)")
                                        
                                        isReminderPresent = true
                                    }

                                } label: {
                                    Image(systemName: "bell")
                                }

                            }
                    }

                } else {

                    // show the loading view based on status
                    if drugVM.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.5)
                            .padding(.top, 20)
                        Spacer()
                    } else {
                        // we have nothing to show
                        ScrollView {
                            ContentUnavailableView("You don't have any medications to show", image: "drug_icon", description: nil)
                        }
                    }

                }

                // the button that shows search view
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
        // show searchview to make a search
        .sheet(isPresented: $isSearchViewPresent) {
            SearchMedication(sheetShowing: $isSearchViewPresent)
        }
        // show the add event option from system
        .sheet(isPresented: $isReminderPresent, content: {
            ReminderView(store: store)
        })
        // if there is any error, it'll show here
        .onChange(of: drugVM.medicationDeleteMessage, { oldValue, newValue in
            if !newValue.isEmpty {
                isAlertPresent = true
            }
        })
        .alert(drugVM.medicationDeleteMessage, isPresented: $isAlertPresent) {
            Button {
                isAlertPresent.toggle()
                // reseting it for next use
                drugVM.medicationDeleteMessage = ""
            } label: {
                Text("Dismiss")
            }
        }
        .onAppear {
            drugVM.isLoading = true
                Task {
                    await drugVM.getUserDrugs()
                }
        }
    }
}
