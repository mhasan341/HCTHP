//
//  MedicationItem.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct MedicationItem: View {
    var medineName: String = "Medicine 1"
    var body: some View {
        HStack {
            Image("drug_icon")
                .resizable()
                .frame(width: 32, height: 32)

            Text(medineName)
                .font(.title2)
        }
    }
}

#Preview {
    MedicationItem()
}
