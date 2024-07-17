//
//  ContentView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthVM
    
    var body: some View {
        if authVM.isLoggedIn {
            MedicationHome()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
