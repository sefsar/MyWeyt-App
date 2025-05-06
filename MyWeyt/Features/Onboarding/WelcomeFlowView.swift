//
//  WelcomeFlowView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct WelcomeFlowView: View {
    @EnvironmentObject var flow: AppFlowManager
    @State private var currentPage = 0

    let totalPages = 4

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                WelcomePageView(
                    title: "Welcome to MyWeyt",
                    description: "Track your weight easily and stay motivated.",
                    imageName: "WelcomeToMyWeyt"
                        
                ).tag(0)

                WelcomePageView(
                    title: "See Your Progress",
                    description: "Visualize your weight journey over time.",
                    imageName: "SeeYourProgress"
                ).tag(1)

                WelcomePageView(
                    title: "Be Consitent & Patient",
                    description: "Proceed with patience and short steps.",
                    imageName: "ConsistentAndPatient"
                ).tag(2)

            
                VStack(spacing: 20) {
                    CombinedLoginView(
                        
                    )
                    .padding(.horizontal)
                }
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)

            if currentPage < totalPages - 1 {
                Button(action: {
                    withAnimation {
                        currentPage += 1
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 220)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(80)
                        .padding()
                }
                
            }
        }
    }
}


#Preview {
    WelcomeFlowView()
}
