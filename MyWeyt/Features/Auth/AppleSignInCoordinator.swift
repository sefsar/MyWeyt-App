//
//  AppleSignInCoordinator.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 18.05.25.
//

import AuthenticationServices
import FirebaseAuth
import SwiftUI

class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var currentNonce: String?
    private var flow: AppFlowManager?
    
    // Callback closures for animation coordination
    var onSignInSuccess: (() -> Void)?
    var onSignInError: (() -> Void)?

    init(flow: AppFlowManager? = nil) {
        self.flow = flow
        super.init()
        print("AppleSignInCoordinator initialized")
    }

    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        print("Generated nonce: \(nonce.prefix(5))...")

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        print("Performing Apple Sign-In request")
        authorizationController.performRequests()
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print("Providing presentation anchor")
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Authorization completed successfully")
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ Error: Could not get ASAuthorizationAppleIDCredential")
            onSignInError?()
            return
        }
        
        guard let identityToken = appleIDCredential.identityToken else {
            print("❌ Error: Could not get identity token")
            onSignInError?()
            return
        }
        
        guard let idTokenString = String(data: identityToken, encoding: .utf8) else {
            print("❌ Error: Could not convert token to string")
            onSignInError?()
            return
        }
        
        guard let nonce = currentNonce else {
            print("❌ Error: No nonce available")
            onSignInError?()
            return
        }
        
        print("All credentials retrieved successfully")

        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )

        print("Signing in with Firebase")
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                print("❌ Firebase sign-in failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.onSignInError?()
                }
                return
            }

            let email = result?.user.email ?? "No Email"
            print("✅ Signed in with Firebase: \(email)")

            // Call success callback for animations on the main thread
            DispatchQueue.main.async {
                print("Calling onSignInSuccess callback")
                self?.onSignInSuccess?()
            }
            
            // Original implementation (kept for backward compatibility)
            // This should not be needed anymore as we're using the callback
            /*
            DispatchQueue.main.async {
                self?.flow?.completeLogin()
            }
            */
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple Sign-In failed: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.onSignInError?()
        }
    }
}

