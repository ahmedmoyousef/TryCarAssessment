//
//  PostsView.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import SwiftUI

struct PostsView: View {
    @State private var viewModel = PostsViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.paths) {
            ZStack {
                Group {
                    if viewModel.posts.isEmpty, !viewModel.isLoading {
                        EmptyStateView(isOffline: !viewModel.isConnected)
                    } else {
                        List {
                            if !viewModel.isConnected {
                                offlineNoticeSection
                            }
                            
                            postsSection
                        }
                        .accessibilityIdentifier("postsList")
                        .refreshable {
                            await viewModel.fetchPosts(forceRefresh: true)
                        }
                    }
                }
            }
            .loadingOverlay(isLoading: viewModel.isLoading)
            .navigationTitle("Posts")
            .navigationDestination(for: PostsPath.self) { path in
                switch path {
                case .postDetail(let post):
                    PostsFactory.postDetails(post).view
                default:
                    Text("Post")
                }
            }
            .task {
                await viewModel.fetchPosts()
            }
        }
    }
    
    private var offlineNoticeSection: some View {
        Section {
            HStack {
                Image(systemName: "wifi.slash")
                Text("You're offline")
                Spacer()
                Text("Pull to refresh")
                    .foregroundColor(.blue)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
    
    private var postsSection: some View {
        ForEach(viewModel.posts) { post in
            PostRowView(post: post)
                .accessibilityIdentifier("postRow_\(post.id)")
                .onTapGesture {
                    viewModel.didSelect(post: post)
                }
        }
    }
}

private struct EmptyStateView: View {
    let isOffline: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: isOffline ? "wifi.slash" : "doc.text.image")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .accessibilityLabel(isOffline ? "Offline icon" : "Empty posts icon")
            
            Text(isOffline ? "No Posts Available Offline" : "No Posts Found")
                .font(.title2)
                .foregroundColor(.primary)
                .accessibilityAddTraits(.isHeader)
            
            Text(isOffline ? "Connect to the internet to load posts" : "Check back later for new posts")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if isOffline {
                Button(action: {
                    // This will trigger the refreshable action
                    NotificationCenter.default.post(name: .init("RefreshPosts"), object: nil)
                }) {
                    Label("Try Again", systemImage: "arrow.clockwise")
                        .foregroundColor(.blue)
                }
                .padding(.top)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .accessibilityIdentifier("emptyStateView")
    }
}

#Preview {
    PostsView()
}

