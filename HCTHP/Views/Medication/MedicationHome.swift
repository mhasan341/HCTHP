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
    // view model that manages the backend calls and publishes result or error
    @StateObject private var drugVM = DrugVM()
    // this flag makes the SearchView appear/disappear as modal
    @State private var isSearchViewPresent = false
    // errors are presented to user using this alert
    @State private var isAlertPresent = false
    // the EKEventEditVC is presented as modal using this flag
    @State private var isReminderPresent = false

    let store = EKEventStore(sources: .init())

    var body: some View {
        NavigationStack {
            VStack {
                // if no data is loading and we don't have a empty list, only then we want to show the data
                if !drugVM.isLoading && !drugVM.savedDrugs.isEmpty {
                    
                    List(drugVM.savedDrugs ) { item in

                        MedicationItem(medineName: item.name)
                        // delete on left swipe
                            .swipeActions(edge: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/, allowsFullSwipe: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                                Button("Delete"){
                                    Task {
                                        await drugVM.deleteDrugOf(rxcui: item.id)
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
                            // scrollView tightens view, so we want to put some space
                            Spacer(minLength: 200)
                            // we may opt for a system image as well
                            //ContentUnavailableView("You don't have any medications to show", image: "drug_icon", description: nil)
                            // Actuall this looks better
                            ContentUnavailableView("You don't have any medications to show", systemImage: "pills.circle")
                        }
                    }

                }

                // the button that shows search view
                SearchMedicationButton {
                    isSearchViewPresent = true
                }
            }
            // pull to refresh action
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
        // after we delete a drug from user's medication list the backend sends a success message
        // we're showing it here, and making sure to empty that error message, so if we delete another
        // the condition above triggers and the alert below shows
        .alert(drugVM.medicationDeleteMessage, isPresented: $isAlertPresent) {
            Button {
                isAlertPresent.toggle()
                // reseting it for next use
                drugVM.medicationDeleteMessage = ""
            } label: {
                Text("Dismiss")
            }
        }
        // when user logs in or registers, we want to fetch the drugs he saved (if any)
        .onAppear {
                Task {
                    await drugVM.getUserDrugs()
                }
        }
    }
}
