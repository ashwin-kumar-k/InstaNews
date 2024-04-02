//
//  BookMarkView.swift
//  InstaNews
//
//  Created by Ashwin Kumar on 18/03/24.
//

import SwiftUI
import Foundation

// Struct representing an API client for fetching news articles
struct NewsAPI {
    
    // Singleton instance to access the API
    static let shared = NewsAPI()
    private init() {} // Private initializer to prevent external instantiation
    
    // API key for accessing the news API
    private let apiKey = "b032db1c51a542449f02b1b4bc4e7c44"
    
    // URLSession for making network requests
    private let session = URLSession.shared
    
    // JSON decoder for parsing JSON responses
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Configure date decoding strategy
        return decoder
    }()
    
    // Fetch news articles based on category
    func fetch(from category: Category) async throws -> [Article] {
        try await fetchArticles(from: generateNewsURL(from: category))
    }
    
    // Search for news articles based on query
    func search(for query: String) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query))
    }
    
    // Fetch articles from a given URL
    private func fetchArticles(from url: URL) async throws -> [Article] {
        let (data, response) = try await session.data(from: url)
        
        // Ensure the response is HTTPURLResponse
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        
        // Check the status code of the response
        switch response.statusCode {
                
                // If status code is within success or client error range
            case (200...299), (400...499):
                // Decode API response
                let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
                // Check if API response status is "ok"
                if apiResponse.status == "ok" {
                    return apiResponse.articles ?? [] // Return articles if available
                } else {
                    // Throw an error with API response message
                    throw generateError(description: apiResponse.message ?? "An error occured")
                }
                // For all other status codes, throw a server error
            default:
                throw generateError(description: "A server error occured")
        }
    }
    
    // Generate a custom error
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    // Generate search URL based on query
    private func generateSearchURL(from query: String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    
    // Generate news URL based on category
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?country=in"
        url += "&apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)!
    }
}
