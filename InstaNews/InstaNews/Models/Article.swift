//
//  Article.swift
//  News
//
//  Created by Ashwin Kumar on 12/03/24.
//

import Foundation
import SwiftUI
import SwiftData

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()
// Struct representing the response from the News API
struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]? // Array of articles
    
    let code: String?
    let message: String?
}

// Struct representing an article
struct Article: Codable, Identifiable {
    let id = UUID() // Unique identifier
    let source: Source // Source of the article
    let title: String // Title of the article
    let url: String // URL of the article
    let publishedAt: Date // Publication date of the article
    
    let author: String? // Author of the article
    let description: String? // Description of the article
    let urlToImage: String? // URL of the article's image
    
    // Coding keys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case source
        case title
        case url
        case publishedAt
        case author
        case description
        case urlToImage
    }
    
    // Computed properties
    
    // Author text, returns empty string if nil
    var authorText: String {
        return author ?? ""
    }
    
    // Description text, returns empty string if nil
    var descriptionText: String {
        return description ?? ""
    }
    
    // Article URL
    var articleURL: URL {
        return URL(string: url)!
    }
    
    // Image URL, returns nil if urlToImage is nil
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
    
    // Source name
    var sourceName: String {
        return "\(source.name)"
    }
    
    // Relative date string using RelativeDateTimeFormatter
    var relativeDate: String {
        return "\(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: .now))"
    }
}

// Struct representing the source of an article
struct Source: Codable, Equatable {
    let name: String // Name of the source
}

// Extension to Article for providing preview data
extension Article {
    static var previewData: [Article] {
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")! // URL of the preview JSON file
        
        let data = try! Data(contentsOf: previewDataURL) // Read data from JSON file
        
        let jsonDecoder = JSONDecoder() // JSON decoder
        jsonDecoder.dateDecodingStrategy = .iso8601 // Date decoding strategy
        
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data) // Decode JSON into NewsAPIResponse
        
        return apiResponse.articles ?? [] // Return articles from the API response
    }
}

// Class representing a bookmarked article
@Model
class BookMark {
    let id = UUID() // Unique identifier
    let source: Source // Source of the article
    let title: String // Title of the article
    let url: String // URL of the article
    let publishedAt: Date // Publication date of the article
    let urlToImage: String // URL of the article's image
    
    // Initializer
    init(source: Source, title: String, url: String, publishedAt: Date, urlToImage: String) {
        self.source = source
        self.title = title
        self.url = url
        self.publishedAt = publishedAt
        self.urlToImage = urlToImage
    }
}
