//
//  MedicationDetail.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-19.
//

import SwiftUI

struct MedicationDetail: View {
    @EnvironmentObject private var drugVM: DrugVM
    var drugId: String
    @State private var isAlertPresent = false

    var body: some View {
        VStack(alignment: .leading) {
            if let detailObject = drugVM.drugDetailObject, let detailData = detailObject.data {

                // to show image on center
                HStack {
                    Spacer()
                    Image("drug_icon")
                        .resizable()
                        .frame(width: 50, height: 50)
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
                    ContentUnavailableView("Couldn't fetch medication details", image: "drug_icon", description: Text(drugVM.errorMessage ?? ""))
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: drugVM.medicationSaveMessage, { oldValue, newValue in
            if !newValue.isEmpty {
                self.isAlertPresent = true
            }
        })
        .alert(drugVM.medicationSaveMessage, isPresented: $isAlertPresent) {
            Button {
                isAlertPresent.toggle()
                // reset it for next use
                drugVM.medicationSaveMessage = ""
            } label: {
                Text("Dismiss")
            }
        }
        .onAppear {
            Task {
                await drugVM.getDrugDetailsFor(rxcui: drugId)
            }
        }

    }
}
