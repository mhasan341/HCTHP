//
//  MedicationDeleteAnimationView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-24.
//

import SwiftUI

struct MedicationDeleteAnimationView: View {

    @Binding var show: Bool
    @Binding var change: Bool
    @Binding var showAnimation: Bool

    var body: some View {
        VStack {
            // pill
            DrugIcon(withSize: 32)
                .opacity(show ? 1 : 0)
                .offset(x: -100, y: change ? 650 : 100)
                .animation(showAnimation ? .interpolatingSpring(stiffness: 10, damping: 20, initialVelocity: -3): .none, value: change)
                .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            // trash
            Spacer()
            Image(systemName: "trash.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(.red)
                .padding(.bottom, 40)
                .offset(x: change ? -100 : -300)
                .animation(.spring(dampingFraction: 0.5), value: change)
                .zIndex(1.0)
        }
    }
}
