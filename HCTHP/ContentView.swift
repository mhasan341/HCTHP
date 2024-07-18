//
//  ContentView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthVM
    
    // here we display the root view of our application based on user's log in status
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
