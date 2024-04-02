//
//  ContentView.swift
//  InstaNews
//
//  Created by Ashwin Kumar on 18/03/24.
//

import SwiftUI

// View for displaying an article card
struct ArticleCardView: View {
    var article :Article // Article to display
    @Environment(\.modelContext) var modelContext
    @State var saved = false // State variable for bookmark status
    
    var body: some View {
        VStack{
            // Async image for article
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                    case .empty:
                        HStack {
                            Spacer()
                            ProgressView() // Show progress view while loading image
                            Spacer()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        HStack {
                            Spacer()
                            Image(systemName: "photo") // Show placeholder if image loading fails
                                .font(.title)
                            Spacer()
                        }
                    @unknown default:
                        fatalError()
                }
            }
            .frame(width: 320, height: 200)
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8.0){
                Text(article.title) // Title of the article
                    .font(.custom("poppins-medium", size: 16))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 50, alignment: .topLeading)
                
                // Article source name and relative date
                HStack {
                    HStack {
                        Text(article.sourceName) // Source name
                            .font(.custom("poppins-regular", size: 14))
                            .foregroundStyle(.orange)
                            .font(.caption)
                            .lineLimit(1)
                        
                        Circle()
                            .fill(.gray)
                            .frame(width: 5)
                        
                        Text(article.relativeDate) // Relative publication date
                            .font(.custom("poppins-regular", size: 14))
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                    .frame(maxWidth: 400, alignment: .leading)
                    
                    Spacer()
                    
                    // Bookmark and share buttons
                    HStack(spacing: 15.0) {
                        Button {
                            saved.toggle()
                            if saved {
                                addBookmark(article: article) // Add bookmark if saved
                            }
                        } label: {
                            Image(systemName: saved ? "bookmark.fill" : "bookmark") // Bookmark button
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(saved ? .orange : .gray)
                                .frame(width:13)
                        }
                        Button {
                            presentShareSheet(url: article.articleURL) // Share button
                        } label: {
                            Image("share") // Share button icon
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 20)
                        }
                    }
                }
            }
            .frame(width: 320)
        }
    }
    
    // Function to add bookmark for the article
    func addBookmark(article: Article) {
        let bookmark = BookMark(source: article.source, title: article.title, url: article.url, publishedAt: article.publishedAt, urlToImage: article.urlToImage!)
        modelContext.insert(bookmark) // Insert bookmark into model context
    }
}

// Preview for ArticleCardView
#Preview {
    ArticleCardView(article: Article.previewData[7]) // Preview with sample article data
}

// Extension to View for presenting a share sheet with URL
extension View {
    func presentShareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}

// View for displaying an empty article card
struct ArticleCardViewEmpty: View {
    
    var body: some View {
        VStack{
            // Placeholder rectangle for image
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(width: 320, height: 200)
                .cornerRadius(8)
            
            // Placeholders for article details
            VStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .frame(height: 20)
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .frame(height: 20)
            }
            .frame(width:320,height: 20)
            .padding(.vertical)
            
            // Placeholder for bookmark and share buttons
            HStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .frame(width: 150, height: 20)
                Spacer()
                HStack(spacing: 15.0) {
                    Button {} label: {
                        Image(systemName: "bookmark") // Bookmark button
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width:13)
                    }
                    Button {} label: {
                        Image("share") // Share button
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: 20)
                    }
                }
            }
            .frame(width:320,height: 20)
        }
    }
}

// Preview for ArticleCardViewEmpty
#Preview {
    ArticleCardViewEmpty() // Preview for empty article card
}
