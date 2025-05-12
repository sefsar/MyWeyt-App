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

            TextField("Your name", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)

            if showError {
                Text("Username cannot be empty.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
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
    }

    func saveUserLocally() {
        // For now we'll use UserDefaults (we can replace this with CoreData later)
        UserDefaults.standard.set(username, forKey: "localUsername")
    }
}

#Preview {
    LocalLoginView()
        .environmentObject(AppFlowManager())
}
