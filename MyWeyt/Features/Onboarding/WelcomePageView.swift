//
//  WelcomePageView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct WelcomePageView: View {
    let title: String
    let description: String
    let imageName: String
    var isFirstPage: Bool = false // Default false for others

    
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Image from assets
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .opacity(animateContent ? 1 : 0)
            
            // Text content
            VStack(spacing: 20) {
                            if isFirstPage {
                                HStack(spacing: 4) {
                                    Text("Welcome to ")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)

                                    Text("MyWeyt")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                                .multilineTextAlignment(.center)
                            } else {
                                Text(title)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                            }

                Text(description)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .font(.title2)
                    .foregroundColor(Color(UIColor.systemGray))
            }
            .padding()
            .opacity(animateContent ? 1 : 0)
            
            Spacer()
            
            
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
        .onDisappear {
            animateContent = false
        }
    }
}

#Preview {
    WelcomePageView(title: "title", description: "description", imageName: "WelcomeToMyWeyt")
}
