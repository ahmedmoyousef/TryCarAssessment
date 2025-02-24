//
//  PostsFactory.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 24/02/2025.
//

import Foundation
import SwiftUI

enum PostsFactory {
    case posts
    case postDetails(Post)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .posts:
            PostsView()
        case .postDetails(let post):
            let vm = PostDetailViewModel(post: post)
            PostDetailView(viewModel: vm)
        }
    }
}
