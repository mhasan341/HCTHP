//
//  SearchMedicationView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-19.
//

import SwiftUI

struct SearchMedicationButton: View {
    
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
            Text("Search Medications")
                .bold()
                .font(.body)
        }
        .onTapGesture {
            onTap()
        }
        .foregroundStyle(.accent)
        .padding(.bottom, 40)

    }
}
