//
//  HomeViewModel.swift : # Manages current tab selection
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedTab: TabItem = .home
}
