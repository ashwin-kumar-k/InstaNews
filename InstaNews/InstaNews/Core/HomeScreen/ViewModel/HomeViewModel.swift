//
//  HomeViewModel.swift
//  News
//
//  Created by Ashwin Kumar on 16/03/24.
//

import Foundation
import Observation // Importing Observation for Observable

// ViewModel for managing home screen data
@Observable
class HomeViewModel {
    
    // Instance of NewsAPI for fetching articles
    private let newsAPI = NewsAPI.shared
    
    // Function to load articles asynchronously based on category
    func loadArticles(from category: Category) async -> [Article] {
        do {
            let articles = try await newsAPI.fetch(from: category) // Fetch articles from NewsAPI
            return articles // Return fetched articles
        } catch {
            print(error.localizedDescription) // Print error if any
        }
        return [] // Return empty array if fetching fails
    }
}
