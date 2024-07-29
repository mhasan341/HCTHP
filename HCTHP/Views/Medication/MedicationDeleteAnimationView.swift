//
//  MedicationDeleteAnimationView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-24.
//

import SwiftUI

struct MedicationDeleteAnimationView: View {

    var index: Int
    @Binding var show: Bool
    @Binding var change: Bool
    @Binding var showAnimation: Bool

    var body: some View {
        GeometryReader {proxy in
            VStack {
                // pill
                DrugIcon(withSize: 32)
                    .opacity(show ? 1 : 0)
                    .offset(x: -100, y: change ? proxy.size.height - 120 : CGFloat(index * 50))
                    .animation(showAnimation ? .interactiveSpring(response: 0.85, dampingFraction: 0.7): .none, value: change)
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
            }.frame(width: proxy.size.width, height: proxy.size.height)
        } // GR
    }
}
