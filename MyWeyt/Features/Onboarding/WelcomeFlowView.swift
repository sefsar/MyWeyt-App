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
        ZStack(alignment: .topLeading) {
            VStack {
                TabView(selection: $currentPage) {
                    // Welcome Pages
                    WelcomePageView(
                        title: "Welcome to MyWeyt",
                        description: "\nTrack your weight easily\nand stay motivated.",
                        imageName: "WelcomeToMyWeyt",
                        isFirstPage: true
                    )
                    .tag(0)
                    .transition(.opacity)
                    
                    WelcomePageView(
                        title: "See Your Progress",
                        description: "\nFollow your weight tracking progress through a visual story.",
                        imageName: "SeeYourProgress"
                    )
                    .tag(1)
                    .transition(.opacity)
                    
                    WelcomePageView(
                        title: "Be Consitent & Patient",
                        description: "\nProceed with patience\nand short steps.",
                        imageName: "ConsistentAndPatient"
                    )
                    .tag(2)
                    .transition(.opacity)
                    
                    VStack(spacing: 20) {
                        CombinedLoginView()
                            .padding(.horizontal)
                            .opacity(fadeOpacity)
                    }
                    .tag(3)
                    .transition(.opacity)
                    .onAppear {
                        fadeOpacity = 0.0
                        withAnimation(.easeIn(duration: 1.2)) {
                            fadeOpacity = 1.0
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .onChange(of: currentPage) { oldValue, newValue in
                    if newValue == 3 && oldValue == 2 {
                        withAnimation(.easeInOut(duration: 0.8)) {}
                    }
                }
                
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 20)
                
                // Skip Button
                if currentPage != 3 {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            flow.currentState = .combinedLogin
                        }
                    }) {
                        Text("Skip")
                            .font(.system(size: 14, weight: .regular)) // smaller symbol
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 4) // small space above "Continue"
                }
                
                // Continue Button
                if currentPage < totalPages - 1 {
                    Button(action: {
                        if currentPage == totalPages - 2 {
                            withAnimation(.easeOut(duration: 0.8)) {
                                fadeOpacity = 0.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    currentPage += 1
                                }
                            }
                        } else {
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
            // MARK: X Button
            if currentPage != 3{
                // ❌ Dismiss Button in Top-Right (Only show when not on .combinedLogin)
                Button(action: {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        flow.currentState = .combinedLogin
                    }
                }) {
                    Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold)) // smaller symbol
                            .foregroundColor(.gray)
                            .padding(6) // smaller touch area
                            .background(Color(.systemGray5).opacity(0.4))
                            .clipShape(Circle())

                    }
                    .padding(.leading, 16)
                    .padding(.top, 10)
            }
            
        }
    }
}

#Preview {
    WelcomeFlowView()
}
