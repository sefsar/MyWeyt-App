//
//  CombinedLoginView.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 07.05.25.
//

import SwiftUI
import Combine
#if canImport(UIKit)
import UIKit
#endif

struct CombinedLoginView: View {
    @EnvironmentObject var flow: AppFlowManager
    @State private var selectedLoginType = 0 // 0 for local, 1 for online
    @Namespace private var animation
    
    // MARK: Keyboard handling
    @State private var keyboardHeight: CGFloat = 0
    @State private var isKeyboardVisible = false
    
    // MARK: View Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Background - handle tap to dismiss keyboard
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Dismiss keyboard when tapping outside
                        #if canImport(UIKit)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        #endif
                    }
                
                VStack(spacing: 0) {
                    if isKeyboardVisible{
                        // Spacer to ensure a minimum length from the top safe
                        Spacer(minLength: 140)
                    }
                    // Image at the top
                    if !isKeyboardVisible {
                        Image("CharacterOnScale")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * (isKeyboardVisible ? 0.1 : 0.5))
                            .padding(.top, isKeyboardVisible ? 5 : 20)
                            .transition(.opacity)
                    }
                    
                    
                    // Container for login interface (switcher + content)
                    VStack(spacing: 0) {
                        // Switcher
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
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray6))
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 5)
                        .zIndex(1) // Ensure switcher appears above content
                        
                        // Login content container with clipping
                        ZStack(alignment: .top) {
                            // White background to cover any content during transitions
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width - 48) // Match parent padding
                            
                            // Content with proper transitions
                            if selectedLoginType == 0 {
                                // Local login
                                LocalLoginView()
                                    .frame(width: geometry.size.width - 48) // Fixed width to prevent overflow
                                    .transition(
                                        .asymmetric(
                                            insertion: AnyTransition.opacity.combined(with: .move(edge: .leading)),
                                            removal: AnyTransition.opacity.combined(with: .move(edge: .trailing))
                                        )
                                    )
                            } else {
                                // Online login
                                OnlineLoginView()
                                    .frame(width: geometry.size.width - 48) // Fixed width to prevent overflow
                                    .transition(
                                        .asymmetric(
                                            insertion: AnyTransition.opacity.combined(with: .move(edge: .trailing)),
                                            removal: AnyTransition.opacity.combined(with: .move(edge: .leading))
                                        )
                                    )
                            }
                        }
                        .clipShape(Rectangle()) // Clip the content to prevent overflow
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedLoginType)
                        .offset(y: -5) // Slight overlap with switcher for seamless appearance
                    }
                    .padding(.horizontal, 24)
                    
                    // Add extra space at bottom when keyboard is visible to push content up
                    if isKeyboardVisible {
                        Spacer()
                            .frame(height: keyboardHeight - 20) // Subtract some padding
                    }
                    
                    Spacer() // Push everything up
                }
                .padding(.bottom, isKeyboardVisible ? keyboardHeight : 0)
                .animation(.easeOut(duration: 0.25), value: isKeyboardVisible)
                .animation(.easeOut(duration: 0.25), value: keyboardHeight)
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
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
        }
        // Add keyboard observers
        .onAppear {
            #if canImport(UIKit)
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                keyboardHeight = keyboardFrame.height
                withAnimation {
                    isKeyboardVisible = true
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                withAnimation {
                    isKeyboardVisible = false
                    keyboardHeight = 0
                }
            }
            #endif
        }
        .onDisappear {
            #if canImport(UIKit)
            NotificationCenter.default.removeObserver(self)
            #endif
        }
    }
}

// MARK: Modern tab option -
//                          for the segmented control with glowing effect

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
