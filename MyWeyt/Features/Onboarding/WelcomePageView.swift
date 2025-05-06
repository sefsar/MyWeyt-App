//
//  WelcomePageView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct WelcomePageView: View {
    let title: String
    let description: String
    let imageName: String

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 300 , height: 250)
                .foregroundColor(.blue)
                .transition(.opacity.combined(with: .slide))

            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}



#Preview {
    WelcomePageView(title: "title", description: "description", imageName: "imagename")
}
