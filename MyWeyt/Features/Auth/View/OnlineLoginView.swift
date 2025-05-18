//
//  OnlineLoginView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

struct OnlineLoginView: View {
    @EnvironmentObject var flow: AppFlowManager
    
    // Animation states
    @State private var isAnimating = false
    @State private var isLoading = false
    @State private var isAppleLoading = false
    @State private var fadeOpacity = 1.0
    @State private var showLoggingInMessage = false

    // Create a single instance of the coordinator to prevent recreation on view refresh
    @State private var coordinator = AppleSignInCoordinator()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Login Online")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -20)

            Button(action: {
                // MARK: Integrate Login with Apple
                withAnimation(.easeOut(duration: 0.5)) {
                    isAppleLoading = true
                    fadeOpacity = 0.5
                }
                handleAppleSignIn()
            }) {
                HStack {
                    if isAppleLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 5)
                    } else {
                        Image(systemName: "applelogo")
                    }
                    Text(isAppleLoading ? "Signing in..." : "Login with Apple")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isAppleLoading || isLoading)
            .padding(.horizontal)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)

            Button(action: {
                // MARK: Integrate Login with Google
                withAnimation(.easeOut(duration: 0.5)) {
                    isLoading = true
                    fadeOpacity = 0.5
                }
                handleGoogleSignIn()
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 5)
                    } else {
                        Image(systemName: "globe")
                    }
                    Text(isLoading ? "Signing in..." : "Login with Google")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isLoading || isAppleLoading)
            .padding(.horizontal)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 40)

            if showLoggingInMessage {
                Text("Logging in...")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                    .transition(.opacity)
            }

            Spacer()
        }
        .padding()
        .contentShape(Rectangle())
        .opacity(fadeOpacity)
        .onAppear {
            // Animate elements when view appears
            withAnimation(Animation.easeOut(duration: 0.8).delay(0.1)) {
                isAnimating = true
            }
            
            // Setup coordinator callbacks once when the view appears
            setupAppleCoordinator()
        }
    }
    
    // Configure Apple Sign-In Coordinator
    private func setupAppleCoordinator() {
        coordinator.onSignInSuccess = { 
            // Add print to debug
            print("Apple Sign-In Success Callback Triggered")
            
            // Show logging in message with animation on the main thread
            DispatchQueue.main.async {
                withAnimation(.easeIn(duration: 0.3)) {
                    self.showLoggingInMessage = true
                    self.isAppleLoading = false
                }
                
                // Animate transition to main app
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        self.fadeOpacity = 0.0
                    }
                    
                    // Navigate to main app after fade out completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.flow.completeLogin()
                    }
                }
            }
        }
        
        coordinator.onSignInError = { 
            // Add print to debug
            print("Apple Sign-In Error Callback Triggered")
            
            // Reset UI on the main thread
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.3)) {
                    self.isAppleLoading = false
                    self.fadeOpacity = 1.0
                }
            }
        }
    }
    
    // Initiate Apple Sign-In
    private func handleAppleSignIn() {
        print("Starting Apple Sign-In")
        coordinator.startSignInWithAppleFlow()
    }
    
    // Handling Google Sign in Action
    private func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("No client ID found in Firebase config")
            withAnimation { isLoading = false; fadeOpacity = 1.0 }
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            print("No root view controller found")
            withAnimation { isLoading = false; fadeOpacity = 1.0 }
            return
        }

        Task {
            do {
                let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
                let user = signInResult.user

                guard let idToken = user.idToken?.tokenString else {
                    print("Missing ID token")
                    withAnimation { isLoading = false; fadeOpacity = 1.0 }
                    return
                }
                let accessToken = user.accessToken.tokenString

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: accessToken)

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Firebase Auth error: \(error.localizedDescription)")
                        withAnimation { isLoading = false; fadeOpacity = 1.0 }
                        return
                    }
                    print("User signed in with Google: \(authResult?.user.email ?? "unknown email")")

                    // Show logging in message with animation
                    withAnimation(.easeIn(duration: 0.3)) {
                        showLoggingInMessage = true
                    }
                    
                    // Animate transition to main app
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 1.2)) {
                            fadeOpacity = 0.0
                        }
                        
                        // Navigate to main app after fade out completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            flow.completeLogin()
                        }
                    }
                }
            } catch {
                print("Google Sign-In failed: \(error.localizedDescription)")
                withAnimation(.easeOut(duration: 0.3)) {
                    isLoading = false
                    fadeOpacity = 1.0
                }
            }
        }
    }
    
    // Safe way to hide the keyboard if needed
    private func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

#Preview {
    OnlineLoginView()
        .environmentObject(AppFlowManager())
}
