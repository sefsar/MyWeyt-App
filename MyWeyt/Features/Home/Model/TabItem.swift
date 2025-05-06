//
//  TabItem.swift : # Enums for tab items
//
import Foundation
import SwiftUI

enum TabItem: Int, CaseIterable {
    case home, add, profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .add: return ""
        case .profile: return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .add: return "plus"
        case .profile: return "person.fill"
        }
    }
}
