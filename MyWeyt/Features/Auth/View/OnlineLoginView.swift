//
//  OnlineLoginView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct OnlineLoginScreen: View {
    @EnvironmentObject var flow: AppFlowManager

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Login Online")
                .font(.title2)
                .bold()

            Button(action: {
                // TODO: Integrate Sign in with Apple
                print("Sign in with Apple")
            }) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Sign in with Apple")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Button(action: {
                // TODO: Integrate Sign in with Google
                print("Sign in with Google")
            }) {
                HStack {
                    Image(systemName: "globe")
                    Text("Sign in with Google")
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
    }
}


#Preview {
    OnlineLoginScreen()
}
