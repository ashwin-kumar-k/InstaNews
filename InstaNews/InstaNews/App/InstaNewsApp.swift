//
//  InstaNewsApp.swift
//  InstaNews
//
//  Created by Ashwin Kumar on 18/03/24.
//

import SwiftUI
import SwiftData
@main
struct InstaNewsApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: BookMark.self)
        }
    }
}
