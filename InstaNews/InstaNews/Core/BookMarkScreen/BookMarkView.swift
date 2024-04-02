//
//  BookMarkView.swift
//  InstaNews
//
//  Created by Ashwin Kumar on 18/03/24.
//

import SwiftUI
import SwiftData

// View displaying bookmarks
struct BookMarkView: View {
    
    // Environment property for accessing managed object context
    @Environment(\.modelContext) var modelContext
    
    // State property to track the selected article
    @State var selectedArticle : Article?
    
    // Query property for fetching bookmarks
    @Query var bookmarks: [BookMark]
    
    var body: some View {
        VStack{
            // Header with title and edit button
            HStack {
                Text("Bookmarks")
                    .font(.custom("poppins-semibold", size: 25))
                Spacer()
                EditButton()
            }
            .padding(.horizontal)
            
            // Display bookmarks list or content unavailable message
            if !bookmarks.isEmpty {
                List {
                    ForEach(bookmarks) { bookmark in
                        // Construct article from bookmark data
                        let article = Article(source: bookmark.source, title: bookmark.title, url: bookmark.url, publishedAt: bookmark.publishedAt, author: "", description: "", urlToImage: bookmark.urlToImage)
                        // Display article row
                        ArticleRowView(article: article, saved: true)
                            .onTapGesture {
                                selectedArticle = article // Set selected article
                            }
                    }
                    .onDelete(perform: deleteBookmark) // Enable deletion of bookmarks
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .padding(.horizontal, -10)
            } else {
                // Display content unavailable message if no bookmarks
                ContentUnavailableView("No Bookmarks", systemImage: "bookmark")
            }
            
            Spacer()
        }
        // Full screen cover for displaying article in SafariView
        .fullScreenCover(item: $selectedArticle) { article in
            SafariView(url: article.articleURL)
                .ignoresSafeArea()
        }
    }
    
    // Function to delete bookmarks
    func deleteBookmark(_ indexSet: IndexSet) {
        for index in indexSet {
            let bookmark = bookmarks[index]
            modelContext.delete(bookmark) // Delete bookmark from managed object context
        }
    }
}

// Preview for BookMarkView
#Preview {
    BookMarkView()
}
