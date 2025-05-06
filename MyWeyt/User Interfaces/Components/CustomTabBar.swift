//
//  CustomTabBar.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Spacer()
                if tab == .add {
                    Button(action: {
                        selectedTab = tab
                    }) {
                        Image(systemName: tab.iconName)
                            .resizable()
                            .frame(width: 40, height: 40) // Bigger plus icon
                            .foregroundColor(.white)
                            .padding(22)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                    }
                    .offset(y: -0) // Raised above tab bar
                } else {
                    Button(action: {
                        selectedTab = tab
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tab.iconName)
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text(tab.title)
                                .font(.caption2)
                        }
                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                    }
                }
                Spacer()
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(
            Color(UIColor.systemBackground)
                .ignoresSafeArea(edges: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 0))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: -1) // Soft shadow instead of lines
    }
}
