//
//  LocalLoginView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct LocalLoginView: View {
    @EnvironmentObject var flow: AppFlowManager
    @State private var username: String = ""
    @State private var showError = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Enter a Username")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)

            TextField("Your username", text: $username)
                .font(.system(size: 20, weight: .semibold)) // semibold
                .padding(.vertical, 10) // Vertical padding for height
                .padding(.horizontal)
                .background(Color(.systemBlue.withAlphaComponent(0.2))) // Background color
                .cornerRadius(10) // Rounded corners
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1) // Border
                )
                .autocapitalization(.none)
                .frame(maxWidth: 330)


            if showError {
                Text("Username cannot be empty.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
                // Dismiss keyboard using the responder chain
                #if canImport(UIKit)
                hideKeyboard()
                #endif
                
                if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showError = true
                } else {
                    saveUserLocally()
                    flow.completeLogin()
                }
            }) {
                Text("Continue")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .frame(maxWidth: 220)
                    .font(.headline)
                    .cornerRadius(80)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            // Dismiss keyboard when tapping outside the text field
            #if canImport(UIKit)
            hideKeyboard()
            #endif
        }
    }

    func saveUserLocally() {
        // For now we'll use UserDefaults (we can replace this with CoreData later)
        UserDefaults.standard.set(username, forKey: "localUsername")
    }
    
    // Safe way to hide the keyboard
    private func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

#Preview {
    LocalLoginView()
}
