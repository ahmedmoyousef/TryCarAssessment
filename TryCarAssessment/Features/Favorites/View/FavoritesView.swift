//
//  FavoritesView.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import SwiftUI

struct FavoritesView: View {
    @State private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.paths) {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .accessibilityIdentifier("loadingIndicator")
                } else if viewModel.favoritePosts.isEmpty {
                    EmptyStateView()
                        .accessibilityIdentifier("emptyStateView")
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Favorites")
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error occurred")
            }
            .onAppear {
                Task {
                    await viewModel.loadFavorites()
                }
            }
            .navigationDestination(for: PostsPath.self) { path in
                switch path {
                case .postDetail(let post):
                    PostsFactory.postDetails(post).view
                default:
                    Text("Post")
                }
            }
        }
    }
    
    private var favoritesList: some View {
        List {
            ForEach(viewModel.favoritePosts) { post in
                PostRowView(post: post)
                    .accessibilityIdentifier("favoritePost_\(post.id)")
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.removeFavorite(post: post)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                        .accessibilityIdentifier("removeFavoriteButton")
                    }
                    .onTapGesture {
                        viewModel.didSelect(post: post)
                    }
            }
        }
        .accessibilityIdentifier("favoritesList")
        .refreshable {
            await viewModel.loadFavorites()
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .accessibilityLabel("Empty favorites icon")
            
            Text("No Favorites Yet")
                .font(.title2)
                .foregroundColor(.primary)
                .accessibilityAddTraits(.isHeader)
            
            Text("Posts you favorite will appear here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    FavoritesView()
} 
