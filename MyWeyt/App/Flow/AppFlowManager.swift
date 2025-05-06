import SwiftUI

class AppFlowManager: ObservableObject {
    enum FlowState {
        case onboarding
        case chooseStorage
        case localLogin
        case onlineLogin
        case combinedLogin
        case mainApp
    }

    @Published var currentState: FlowState = .onboarding

    // Direct transition from onboarding to combined login with medium-length fade in
    func nextFromOnboarding() {
        // Use a medium-length fade in duration (0.8 seconds)
        withAnimation(.easeInOut(duration: 3.5)) {
            currentState = .combinedLogin
        }
    }
    
    // Original method kept for backward compatibility
    func nextToStorageChoice() {
        withAnimation(.easeInOut(duration: 3.5)) {
            currentState = .combinedLogin
        }
    }

    func chooseLocal() {
        currentState = .localLogin
    }

    func chooseOnline() {
        currentState = .onlineLogin
    }
    
    func chooseCombinedLogin() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentState = .combinedLogin
        }
    }

    func completeLogin() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentState = .mainApp
        }
    }
}
