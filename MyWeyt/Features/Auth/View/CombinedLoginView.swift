//
//  CombinedLoginView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 07.05.25.
//

import SwiftUI

// Import the App Flow Manager
@_spi(Skip) import class MyWeyt.AppFlowManager

struct CombinedLoginView: View {
    @EnvironmentObject var flow: AppFlowManager
    @State private var selectedLoginType = 0 // 0 for local, 1 for online
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Add some space at the top for better positioning
                Spacer(minLength: 60)
                
                // App name or logo could go here
                Text("MyWeyt")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                
                // Modern custom segmented control for login type with glowing effect
                HStack(spacing: 0) {
                    // Local login tab
                    TabOption(
                        title: "Local",
                        isSelected: selectedLoginType == 0,
                        namespace: animation
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedLoginType = 0
                        }
                    }
                    
                    // Online login tab
                    TabOption(
                        title: "Online",
                        isSelected: selectedLoginType == 1,
                        namespace: animation
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedLoginType = 1
                        }
                    }
                }
                .background(
                    // Container background
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                )
                // Add shadow to the whole switcher
                .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 5)
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                
                // Swipeable content area
                ZStack {
                    // Local login view
                    if selectedLoginType == 0 {
                        LocalLoginScreen()
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading),
                                removal: .move(edge: .trailing)
                            ))
                    } else {
                        // Online login view
                        OnlineLoginScreen()
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    }
                }
                .animation(.spring(), value: selectedLoginType)
                
                Spacer(minLength: 20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        // Implement swipe gesture to change tabs
                        let threshold = geometry.size.width * 0.25
                        if gesture.translation.width > threshold && selectedLoginType == 1 {
                            withAnimation(.spring()) {
                                selectedLoginType = 0
                            }
                        } else if gesture.translation.width < -threshold && selectedLoginType == 0 {
                            withAnimation(.spring()) {
                                selectedLoginType = 1
                            }
                        }
                    }
            )
        }
        .background(Color(.systemBackground))
    }
}

// Modern tab option for the segmented control with glowing effect
struct TabOption: View {
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(isSelected ? .bold : .medium)
            .foregroundColor(isSelected ? .white : .secondary)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if isSelected {
                        // Glowing background for selected tab
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                            .matchedGeometryEffect(id: "BACKGROUND", in: namespace)
                            .overlay(
                                // Inner glow effect
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                    .blur(radius: 0.5)
                            )
                            // Outer glow effect
                            .shadow(color: Color.blue.opacity(0.5), radius: 8, x: 0, y: 0)
                    } else {
                        // Transparent background for unselected tab
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.clear)
                    }
                }
            )
            .contentShape(Rectangle())
            .padding(4) // Add padding to create space between tabs
    }
}

// Preview
struct CombinedLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedLoginView()
    }
}

// Your existing views (placeholders here)
struct LocalLoginView: View {
    var body: some View {
        // Your existing local login implementation
        VStack {
            Text("Local Login")
            // Username/password fields, etc.
        }
    }
}

struct vOnlineLoginView: View {
    var body: some View {
        // Your existing online login implementation
        VStack {
            Text("Online Login")
            // Apple/Google sign-in buttons, etc.
        }
    }
}
