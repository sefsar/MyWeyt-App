//
//  MyWeytApp.swift
//  MyWeyt
//
//  Created by Sefa Sarikaya on 04.05.25.
//
import SwiftUI
import Firebase
import GoogleSignIn

// 1. AppDelegate for Firebase init and other lifecycle hooks
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                         open url: URL,
                         options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        }
}

// 2. Your main SwiftUI App struct
@main
struct MyWeytApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var flowManager = AppFlowManager()

    var body: some Scene {
        WindowGroup {
            RootFlowView()
                .environmentObject(flowManager)
                .preferredColorScheme(.light)
        }
    }
}
