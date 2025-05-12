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
    @State private var fadeOpacity = 1.0 // For controlling fade animations

    let totalPages = 4

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                // Welcome page 1
                WelcomePageView(
                    title: "Welcome to MyWeyt",
                    description: "\nTrack your weight easily\nand stay motivated.",
                    imageName: "WelcomeToMyWeyt",
                    isFirstPage:  true
                    
                )
                .tag(0)
                .transition(.opacity)

                // Welcome page 2
                WelcomePageView(
                    title: "See Your Progress",
                    description: "\nFollow your weight tracking progress through a visual story.",
                    imageName: "SeeYourProgress"
                )
                .tag(1)
                .transition(.opacity)

                // Welcome page 3
                WelcomePageView(
                    title: "Be Consitent & Patient",
                    description: "\nProceed with patience\nand short steps.",
                    imageName: "ConsistentAndPatient"
                )
                .tag(2)
                .transition(.opacity)
            
                // Login page (tag 3)
                VStack(spacing: 20) {
                    CombinedLoginView()
                    .padding(.horizontal)
                    .opacity(fadeOpacity) // Control the fade-in of login view
                }
                .tag(3)
                .transition(.opacity)
                .onAppear {
                    // When this view appears, start with low opacity and fade in
                    fadeOpacity = 0.0
                    withAnimation(.easeIn(duration: 1.2)) {
                        fadeOpacity = 1.0
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onChange(of: currentPage) { oldValue, newValue in
                // When switching to login page, apply smooth fade animation
                if newValue == 3 && oldValue == 2 {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        // This animation will apply to the TabView transition
                    }
                }
            }
            
            // Dot indicator for Page structure
            
            HStack(spacing: 8) {
                            ForEach(0..<totalPages, id: \.self) { index in
                                Circle()
                                    .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .padding(.bottom, 20)
            
            // Continue Button Config + Features

            if currentPage < totalPages - 1 {
                Button(action: {
                    // For the last welcome page, add fade out effect before moving to login
                    if currentPage == totalPages - 2 {
                        withAnimation(.easeOut(duration: 0.8)) {
                            // Begin fade out of current page
                            fadeOpacity = 0.0
                        }
                        
                        // After a short delay, move to the next page
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                currentPage += 1
                            }
                        }
                    } else {
                        // Regular page transition for other pages
                        withAnimation {
                            currentPage += 1
                        }
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
