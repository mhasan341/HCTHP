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

    var body: some View {
        VStack {
            if let detailObject = drugVM.drugDetailObject, let detailData = detailObject.data {
                Image("drug_icon")
                    .resizable()
                    .frame(width: 50, height: 50)

                Text(detailData.name)
                Text(detailData.synonym)
            } else {
                if !drugVM.isLoading {
                    ContentUnavailableView("Couldn't fetch medication details", image: "drug_icon", description: Text(drugVM.errorMessage ?? ""))
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await drugVM.getDrugDetails(by: drugId)
            }
        }

    }
}
