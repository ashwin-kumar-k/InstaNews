//
//  SearchView.swift
//  InstaNews
//
//  Created by Ashwin Kumar on 18/03/24.
//

import SwiftUI

// View for searching articles
struct SearchView: View {
    
    // State property for search text
    @State var searchText: String = ""
    
    // State property for storing search results
    @State var articles: [Article] = []
    
    // State property for selected article
    @State var selectedArticle : Article?
    
    var body: some View {
        NavigationStack { // Custom navigation stack
            
            ScrollView(.vertical, showsIndicators: false){ // Vertical scroll view
                LazyVStack { // LazyVStack for efficient rendering
                    if !articles.isEmpty { // If articles are available
                        ForEach(articles){ article in
                            ArticleRowView(article: article) // Display article row
                                .padding(.vertical)
                                .onTapGesture {
                                    selectedArticle = article // Set selected article
                                }
                            
                        }
                    }
                    else{
                        ContentUnavailableView.search // Display content unavailable message for search
                    }
                    
                }
                .padding(.top)
            }
            .searchable(text: $searchText, prompt: Text("Search Articles")) // Enable search functionality
            .onChange(of: searchText, { oldValue, newValue in // Handle text change
                if newValue.isEmpty {
                    articles.removeAll() // Clear articles when search text is empty
                }
            })
            .onSubmit(of: .search) { // Handle search submission
                Task {
                    articles = await loadArticles(from: searchText) // Fetch articles based on search text
                }
            }
            .toolbar{ // Toolbar
                ToolbarItem(placement: .topBarLeading) {
                    Text("Search") // Title for search view
                        .font(.custom("poppins-semibold", size: 25))
                    
                }
            }
            .fullScreenCover(item: $selectedArticle) { article in // Full screen cover for displaying article in SafariView
                SafariView(url: article.articleURL)
                    .ignoresSafeArea()
            }
        }
        
    }
    
    // Instance of NewsAPI for fetching articles
    private let newsAPI = NewsAPI.shared
    
    // Function to load articles asynchronously based on search text
    func loadArticles(from text: String ) async -> [Article] {
        do {
            let articles = try await newsAPI.search(for: text) // Fetch articles from NewsAPI based on search text
            return articles // Return fetched articles
        } catch {
            print(error.localizedDescription) // Print error if any
        }
        return [] // Return empty array if fetching fails
    }
}

// Preview for SearchView
#Preview {
    SearchView()
}
