//
//  MainView.swift
//  SocialMediaApp
//
//  Created by Frank Chen on 2024-03-30.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        // MARK: TabView With Recent Posts and Profile Tabs
        TabView {
            PostsView()
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Posts")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        // Changing Tab Table Tint To Black
        .tint(.black)
    }
}

#Preview {
    MainView()
}
