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

    // animation purpose
    @State var change = false
    // prevents animation going back
    @State var showAnimation = false
    // this one makes sure the pill gets visible first so we can see the initial velocity effect
    @State var show = false

    let store = EKEventStore(sources: .init())

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // if no data is loading and we don't have a empty list, only then we want to show the data
                    if !drugVM.isLoading && !drugVM.savedDrugs.isEmpty {
                        List(drugVM.savedDrugs) {item in

                            MedicationItem(medineName: item.name)
                            // delete on left swipe
                                .swipeActions(edge: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/, allowsFullSwipe: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                                    Button("Delete"){
                                        Task {
                                            await drugVM.deleteDrugOf(rxcui: item.id)
                                        }

                                        // start the animation
                                        controlAnimation()
                                    }
                                }.tint(.red)
                            // add reminder on right swipe
                                .swipeActions(edge: .leading, allowsFullSwipe: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                                    // this one adds a reminder
                                    // in real case we could do lots of customization
                                    Button {

                                        if #available(iOS 17.0, *) {
                                            store.requestFullAccessToReminders { isGranted, errors in
                                                print("Reminder Granted? \(isGranted)")

                                                isReminderPresent = true
                                            }
                                        } else {
                                            // Fallback on earlier versions
                                            Task {
                                                do {
                                                    try await store.requestAccess(to: .reminder) { isGranted, errors in
                                                        print("Reminded Granted on 16? \(isGranted)")

                                                        isReminderPresent = true
                                                    }

                                                }
                                            }
                                        }

                                    } label: {
                                        Image(systemName: "bell")
                                    }

                                }
                                .tint(.blue)
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
                            ScrollableContentNotAvailableView(contentTitle: "You don't have any medications to show")
                        }

                    }

                    // the button that shows search view
                    SearchMedicationButton {
                        isSearchViewPresent = true
                    }
                } // VSTack
                // ZStack

                MedicationDeleteAnimationView(show: $show, change: $change
                                              , showAnimation: $showAnimation)

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
        .onChange(of: drugVM.medicationDeleteMessage) { newValue in
            if !newValue.isEmpty {
                isAlertPresent = true
            }
        }
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

    private func controlAnimation(){
        withAnimation {
            show.toggle()
        }

        if #available(iOS 17.0, *) {
            withAnimation {
                change.toggle()
                showAnimation = true
            } completion: {
                showAnimation = false
                change.toggle()
                show.toggle()
            }
        } else {
            // Fallback on earlier versions
            withAnimation {
                change.toggle()
                showAnimation = true
            }

            withAnimation(.default.delay(1)) {
                showAnimation = false
                change.toggle()
                show.toggle()
            }
        }
    }
}
