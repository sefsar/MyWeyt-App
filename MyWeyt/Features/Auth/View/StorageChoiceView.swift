//
//  StorageChoiceView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct StorageChoiceView: View {
    @EnvironmentObject var flow: AppFlowManager

    var body: some View {
        VStack(spacing: 40) {
            Spacer()


            VStack(spacing: 20) {
                Button(action: {
                    flow.chooseCombinedLogin()
                }) {
                    Text("Log In or Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }
}


#Preview {
    StorageChoiceView()
}
