//
//  ArticleRowView.swift
//  InstaNews
//
//  Created by Ashwin Kumar on 18/03/24.
//

import SwiftUI
import SwiftData

// View for displaying a row of article
struct ArticleRowView: View {
    
    // Environment variable for model context
    @Environment(\.modelContext) var modelContext
    
    var article :Article // Article to display
    @State var saved: Bool = false // State variable for bookmark status
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 0.0){
                Text(article.title) // Title of the article
                    .font(.custom("poppins-medium", size: 15))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 50, alignment: .topLeading)
                    .padding(.trailing)
                
                Text(article.sourceName) // Source name
                    .font(.custom("poppins-regular", size: 12))
                    .foregroundStyle(.orange)
                    .font(.caption)
                    .lineLimit(1)
                    .padding(.bottom,5)
                
                HStack(alignment: .bottom) {
                    Text(article.relativeDate) // Relative publication date
                        .font(.custom("poppins-regular", size: 12))
                        .foregroundStyle(.gray)
                        .font(.caption)
                    Spacer()
                    
                    HStack(spacing: 15.0) {
                        Button{
                            saved.toggle()
                            if saved {
                                addBookmark(article: article) // Add bookmark if saved
                            }
                        }label: {
                            Image(systemName: saved ? "bookmark.fill" : "bookmark") // Bookmark button
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(saved ?.orange: .gray)
                                .frame(width:11)
                        }
                        Button{
                            presentShareSheet(url: article.articleURL) // Share button
                        }label: {
                            Image("share") // Share button icon
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 18)
                        }
                    }
                    .padding(.trailing)
                }
            }
            Spacer()
            
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
                                .font(.subheadline)
                            Spacer()
                        }
                    @unknown default:
                        fatalError()
                }
            }
            .frame(width: 90, height: 90)
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    
    // Function to add bookmark for the article
    func addBookmark(article: Article){
        let bookmark = BookMark(source: article.source, title: article.title, url: article.url, publishedAt: article.publishedAt, urlToImage: article.urlToImage!)
        modelContext.insert(bookmark) // Insert bookmark into model context
    }
}

// Preview for ArticleRowView
#Preview {
    ArticleRowView(article: Article.previewData[7]) // Preview with sample article data
}

// View for displaying an empty article row
struct ArticleRowViewEmpty: View {
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 0.0){
                VStack {
                    Rectangle()
                        .fill(.ultraThickMaterial)
                        .frame(height: 20, alignment: .topLeading)
                    Rectangle()
                        .fill(.ultraThickMaterial)
                        .frame(height: 20, alignment: .topLeading)
                }
                .padding(.trailing)
                
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .frame(width: 50, height: 20, alignment: .topLeading)
                    .padding(.vertical,5)
                
                HStack(alignment: .bottom) {
                    Rectangle()
                        .fill(.ultraThickMaterial)
                        .frame(width: 150, height: 20, alignment: .topLeading)
                    Spacer()
                    
                    HStack(spacing: 15.0) {
                        Button{}label: {
                            Image(systemName:"bookmark") // Bookmark button
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width:11)
                        }
                        Button{}label: {
                            Image("share") // Share button
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 18)
                        }
                    }
                    .padding(.trailing)
                }
            }
            Spacer()
            
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(width: 90, height: 90)
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}

// Preview for ArticleRowViewEmpty
#Preview {
    ArticleRowViewEmpty() // Preview for empty article row
}
