//
//  MedicationDetail.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-19.
//

import SwiftUI

struct MedicationDetail: View {
    // viewmodel to call the backend and publish result or error
    @EnvironmentObject private var drugVM: DrugVM
    // to find the drug details we are interested in
    var drugId: String
    // alert to show if the medication save is successful or not
    @State private var isAlertPresent = false

    var body: some View {
        VStack(alignment: .leading) {
            if let detailObject = drugVM.drugDetailObject, let detailData = detailObject.data {
                // to show image on center
                HStack {
                    Spacer()
                    DrugIcon(withSize: 50)
                    Spacer()
                }
                    VStack(alignment: .leading) {
                        MedicationDetailInfoCard(title: "Name", info: detailData.name)
                        MedicationDetailInfoCard(title: "Synonym", info: detailData.synonym)
                        MedicationDetailInfoCard(title: "PSN", info: detailData.psn)
                        MedicationDetailInfoCard(title: "RXCUI", info: detailData.rxcui)
                        MedicationDetailInfoCard(title: "Language", info: detailData.language)
                    }
                    .padding()

                Spacer()
                // we don't need to disable this button as it doesn't depend on anything
                HCActionButton(buttonTitle: "Add Medication to List", shouldDisableButton: .constant(false)) {
                    Task {
                        await drugVM.addDrug(rxcui: drugId)
                    }
                }

            } else {
                if !drugVM.isLoading {
                    ScrollableContentNotAvailableView(contentTitle: "Sorry", contentDescription: drugVM.errorMessage)
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: drugVM.medicationSaveMessage){ newValue in
            if !newValue.isEmpty {
                self.isAlertPresent = true
            }
        }
        // showing an alert to let user know if they have saved this medication to their list or not
        .alert(drugVM.medicationSaveMessage, isPresented: $isAlertPresent) {
            Button {
                isAlertPresent.toggle()
                // reset it for next use
                drugVM.medicationSaveMessage = ""
            } label: {
                Text("Dismiss")
            }
        }
        // refresh the page again on pull
        .refreshable {
            getDrugDetails()
        }
        // when the page appears we want to fetch the details immediately
        .onAppear {
            getDrugDetails()
        }

    }

    private func getDrugDetails(){
        Task {
            await drugVM.getDrugDetailsFor(rxcui: drugId)
        }
    }
}
