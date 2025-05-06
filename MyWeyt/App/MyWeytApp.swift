//
//  MyWeytApp.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//
import SwiftUI

@main
struct MyWeytApp: App {
    @StateObject private var flowManager = AppFlowManager()

    var body: some Scene {
        WindowGroup {
            RootFlowView()
                .environmentObject(flowManager)
                .preferredColorScheme(.light)
        }
    }
}
