//
//  HomeView.swift : # Main screen with TabBar
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedTab) {
                Text("🏠 Home Screen")
                    .tag(TabItem.home)

                Text("➕ Add New Entry")
                    .tag(TabItem.add)

                Text("👤 Profile + Settings Screen")
                    .tag(TabItem.profile)
            }
            .ignoresSafeArea(.keyboard)

            CustomTabBar(selectedTab: $viewModel.selectedTab)
        }
    }
}
#Preview{
    HomeView()
}
