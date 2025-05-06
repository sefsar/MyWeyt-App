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
    @State private var isFadingOut = false
    
    // Welcome pages content
    let pages = [
        PageData(
            title: "Welcome to MyWeyt",
            message: "Track your weight and stay motivated on your health journey.",
            image: "scale.3d"
        ),
        PageData(
            title: "Set Goals",
            message: "Set achievable targets and monitor your progress over time.",
            image: "target"
        ),
        PageData(
            title: "Be Consistent & Patient",
            message: "Small steps every day lead to significant changes over time.",
            image: "chart.line.uptrend.xyaxis"
        )
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    WelcomePage(
                        title: pages[index].title,
                        message: pages[index].message,
                        image: pages[index].image,
                        isLastPage: index == pages.count - 1,
                        onNext: {
                            if index < pages.count - 1 {
                                withAnimation {
                                    currentPage = index + 1
                                }
                            } else {
                                // Start fade out animation with longer duration (1.2 seconds)
                                withAnimation(.easeInOut(duration: 1.2)) {
                                    isFadingOut = true
                                }
                                
                                // After a delay to allow fade out to complete before transitioning
                                // Using a slightly shorter delay than the animation to start the next screen
                                // while this one is still fading out
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    flow.nextFromOnboarding()
                                }
                            }
                        }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)
        }
        .opacity(isFadingOut ? 0 : 1)
    }
}

// Single welcome page view
struct WelcomePage: View {
    let title: String
    let message: String
    let image: String
    let isLastPage: Bool
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
                .padding()
            
            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: onNext) {
                Text(isLastPage ? "Get Started" : "Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
}

// Data model for welcome pages
struct PageData {
    let title: String
    let message: String
    let image: String
}


#Preview {
    WelcomeFlowView()
} 