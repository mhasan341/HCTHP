//
//  MedicationHome.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct MedicationHome: View {
    var body: some View {
        NavigationStack {
            List(0..<4) {_ in
                MedicationItem(medineName: "Hello Medicine")
            }
            .refreshable {
                print("Refreshing")
            }
            .navigationTitle("My Medications")
        }

    }
}

#Preview {
    MedicationHome()
}
