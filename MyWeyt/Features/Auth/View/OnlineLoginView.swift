//
//  OnlineLoginView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct OnlineLoginView: View {
    @EnvironmentObject var flow: AppFlowManager

    var body: some View {
        VStack(spacing: 30) {
            Text("Login Online")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)

            Button(action: {
                // MARK: Integrate Login with Apple
                print("Login with Apple")
            }) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Login with Apple")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Button(action: {
                // MARK: Integrate Login with Google
                print("Login with Google")
            }) {
                HStack {
                    Image(systemName: "globe")
                    Text("Login with Google")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .contentShape(Rectangle())
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
