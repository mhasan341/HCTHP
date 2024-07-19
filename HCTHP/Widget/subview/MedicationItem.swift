//
//  MedicationItem.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

/// Card to show an asset icon with Drug name
struct MedicationItem: View {
    // filled this to be used in test
    var medineName: String = "Medicine 1"

    var body: some View {
        HStack(spacing: 20) {
            Image("drug_icon")
                .resizable()
                .frame(width: 32, height: 32)

            Text(medineName)
                .font(.body)
        }.padding(.vertical, 5)
    }
}
