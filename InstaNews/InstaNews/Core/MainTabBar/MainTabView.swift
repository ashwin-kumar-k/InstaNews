//
//  MainTabView.swift
//  News
//
//  Created by Ashwin Kumar on 16/03/24.
//

import SwiftUI

// Main TabView containing tabs for HomeView, SearchView, and BookMarkView
struct MainTabView: View {
    var body: some View {
        TabView {
            // HomeView tab
            HomeView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            // SearchView tab
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            // BookMarkView tab
            BookMarkView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
        .tint(.orange) // Set tint color for tab bar
    }
}

// Preview for MainTabView
#Preview {
    MainTabView()
}
