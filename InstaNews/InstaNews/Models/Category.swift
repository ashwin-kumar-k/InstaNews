//
//  Category.swift
//  News
//
//  Created by Ashwin Kumar on 16/03/24.
//

// Enumeration representing news categories
enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    // Computed property to get the display text for the category
    var text: String {
        if self == .general {
            return "Top Headlines" // Return "Top Headlines" for the general category
        }
        return rawValue.capitalized // Return capitalized raw value for other categories
    }
    
    // Computed property to get the system image name for the category
    var systemImage: String {
        switch self {
            case .general:
                return "newspaper" // Newspaper icon for general category
            case .business:
                return "building.2" // Business icon
            case .technology:
                return "iphone.gen3" // Smartphone icon
            case .entertainment:
                return "tv" // TV icon
            case .sports:
                return "sportscourt" // Sports court icon
            case .science:
                return "wave.3.right" // Wave icon
            case .health:
                return "heart" // Heart icon
        }
    }
}

// Extension to Category for conforming to Identifiable protocol
extension Category: Identifiable {
    var id: Self { self } // Return self as the identifier
}
