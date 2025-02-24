//
//  PostRowView.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 24/02/2025.
//

import SwiftUI

struct PostRowView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
                .accessibilityIdentifier("postTitle") // Add accessibility identifier
            Text(post.body)
                .font(.subheadline)
                .lineLimit(2)
                .accessibilityIdentifier("postBody") // Add accessibility identifier
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    PostRowView(post: .init(id: 0, userId: 0, title: "", body: ""))
}
