//
//  MedicationDetailInfoCard.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-19.
//

import SwiftUI

struct MedicationDetailInfoCard: View {
    var title: String
    var info: String

    var body: some View {
        HStack{
            Text(title)
                .font(.body)
                .fontWeight(.bold)

            Text(info)
                .font(.caption)
        }
    }
}
