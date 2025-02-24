//
//  PostDetailView.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import SwiftUI

struct PostDetailView: View {
    
    @State private var viewModel: PostDetailViewModel
    
    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section {
                Text(viewModel.post.title)
                    .font(.headline)
                Text(viewModel.post.body)
                    .font(.body)
            }
            
            Section("Comments") {
                ForEach(viewModel.comments) { comment in
                    CommentView(comment: comment)
                }
            }
        }
        .navigationTitle("Post Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.toggleFavorite()
                    }
                } label: {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
                }
            }
        }
        .task {
            await viewModel.fetchComments()
        }
    }
}

struct CommentView: View {
    let comment: PostComment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(comment.email)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(comment.body)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
} 
