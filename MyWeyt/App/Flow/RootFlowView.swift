//
//  RootFlowView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct RootFlowView: View {
    @EnvironmentObject var flow: AppFlowManager
    @State private var isTransitioning = false
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            // Main content with transitions
            Group {
                switch flow.currentState {
                case .onboarding:
                    WelcomeFlowView()
                        .transition(
                            .asymmetric(
                                insertion: .opacity,
                                removal: .opacity.animation(.easeInOut(duration: 1.2))
                            )
                        )
                case .chooseStorage:
                    StorageChoiceView()
                        .transition(.opacity)
                case .localLogin:
                    LocalLoginView()
                        .transition(.slide)
                case .onlineLogin:
                    OnlineLoginView()
                        .transition(.slide)
                case .combinedLogin:
                    CombinedLoginView()
                        .environmentObject(flow)
                        .transition(.opacity)
                case .mainApp:
                    HomeView() // This is your real app screen
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: flow.currentState)
        }
        .onChange(of: flow.currentState) { oldState, newState in
            // Special handling for transition from onboarding to login
            if oldState == .onboarding && newState == .combinedLogin {
                // This change is handled by custom animations in the transitions
                isTransitioning = true
                
                // Reset the transition flag after the animations are complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    isTransitioning = false
                }
            }
        }
    }
}

struct RootFlowView_Previews: PreviewProvider {
    static var previews: some View {
        RootFlowView()
            .environmentObject(AppFlowManager())
    }
}
