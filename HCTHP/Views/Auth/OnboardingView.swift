//
//  OnboardingView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import SwiftUI

struct OnboardingView: View {
    // just a little animation
    @State private var logoScale: CGFloat = 1.0

    var body: some View {

        NavigationStack {
            VStack {
                Spacer()

                Image("logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaleEffect(logoScale)
                    .onAppear {
                        withAnimation(Animation.spring(duration: 1.5).repeatForever(autoreverses: true)) {
                            logoScale = 1.1
                        }
                    }

                Spacer()
                // for simplicity using NavigationLink in this project

                // Takes user to registration view
                NavigationLink(destination: RegistrationView()) {
                    Text("Create New Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)

                // Takes user to login
                NavigationLink(destination: LoginView()) {
                    Text("I already have an account")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 30)

            } // VStack
            .toolbar(.hidden, for: .navigationBar)
        }

    }
}

#Preview {
    OnboardingView()
}
