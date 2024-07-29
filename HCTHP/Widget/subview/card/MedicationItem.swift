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
    /// helps animate row updates in my medication
    @State var scaleEffect = 0.2
    
    var body: some View {
        HStack(spacing: 20) {
            DrugIcon(withSize: 32)
            Text(medineName)
                .font(.body)
                .transition(.scale.animation(.easeInOut))
        }.padding(.vertical, 5)
            .scaleEffect(scaleEffect)
            .onAppear {
                withAnimation(.spring) {
                    scaleEffect = 1.0
                }
            }
    }
}
