//
//  HomeView.swift
//  InstaNews
//
//  Created by Ashwin Kumar on 18/03/24.
//

import SwiftUI

// View displaying the home screen with news articles
struct HomeView: View {
    
    // State property to track the selected article
    @State var selectedArticle : Article?
    
    // Namespace for animation
    @Namespace var animation
    
    // ViewModel for fetching articles
    @State var vm = HomeViewModel()
    
    // State property for selected category
    @State var selectedCategory: Category = .business {
        didSet {
            Task {
                articles = await vm.loadArticles(from: selectedCategory)
            }
        }
    }
    
    // State property for storing articles
    @State var articles: [Article] = []
    
    // State property for storing headlines articles
    @State var harticles: [Article] = []
    
    var body: some View {
        NavigationStack { // Custom navigation stack
            
            ScrollView(.vertical, showsIndicators: false) { // Main vertical scroll view
                VStack(spacing: 0.0) {
                    
                    // Header for top headlines section
                    header()
                    
                    // Horizontal scroll view for top headlines articles
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            if !harticles.isEmpty {
                                ForEach(harticles) { article in
                                    ArticleCardView(article: article)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            selectedArticle = article
                                        }
                                }
                            } else {
                                ForEach(1..<5) { _ in
                                    ArticleCardViewEmpty()
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    
                    Divider()
                        .padding(.top)// Divider
                    
                    // Header for recent stories section
                    recentheader()
                    
                    // Horizontal scroll view for category selection
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 25.0) {
                            ForEach(Category.allCases) { category in
                                if category != .general {
                                    // Category tab
                                    VStack(spacing: 0.0) {
                                        HStack {
                                            Image(systemName: category.systemImage)
                                            Text(category.text)
                                        }
                                        .font(.custom("poppins-Regular", size: 15))
                                        .foregroundColor(selectedCategory == category ? .primary : .gray)
                                        if selectedCategory == category {
                                            RoundedRectangle(cornerRadius: 25.0)
                                                .frame(height: 2)
                                                .foregroundStyle(.orange)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                                .padding(.top,2)
                                        } else {
                                            RoundedRectangle(cornerRadius: 25.0)
                                                .frame(height: 2)
                                                .foregroundColor(.clear)
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.bouncy(duration: 0.5, extraBounce: 0.1)) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Vertical list of articles
                    LazyVStack {
                        if !articles.isEmpty {
                            ForEach(articles) { article in
                                ArticleRowView(article: article)
                                    .padding(.vertical)
                                    .onTapGesture {
                                        selectedArticle = article
                                    }
                            }
                        } else {
                            ForEach(1..<10) { _ in
                                ArticleRowViewEmpty()
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .refreshable(action: { // Pull-to-refresh action
                Task {
                    articles = await vm.loadArticles(from: selectedCategory)
                    harticles = await vm.loadArticles(from: .general)
                }
            })
            .task { // Initial loading task
                articles = await vm.loadArticles(from: selectedCategory)
                harticles = await vm.loadArticles(from: .general)
            }
            .fullScreenCover(item: $selectedArticle) { article in // Full screen cover for displaying article in SafariView
                SafariView(url: article.articleURL)
                    .ignoresSafeArea()
            }
        }
    }
}

// Preview for HomeView
#Preview {
    HomeView()
}

// View for top headlines section header
struct header: View {
    var body: some View {
        HStack {
            Text("Top Headlines")
                .font(.custom("poppins-semibold", size: 25))
            Spacer()
        }
        .padding([.horizontal, .bottom])
    }
}

// View for recent stories section header
struct recentheader: View {
    var body: some View {
        HStack {
            Text("Recent Stories")
                .font(.custom("poppins-semibold", size: 25))
            Spacer()
        }
        .padding([.horizontal, .vertical])
    }
}
