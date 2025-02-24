//
//  PostDetailViewModel.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation
import Combine

@Observable
class PostDetailViewModel: ObservableObject {
    private(set) var comments: [PostComment] = []
    private(set) var error: Error?
    private(set) var isFavorite: Bool = false
    
    private let apiService: APIServiceProtocol
    private let persistenceManager: PersistenceManager
    private let syncManager: SyncManager
    private let networkManager: NetworkManager
    
    let post: Post
    
    init(post: Post,
         apiService: APIServiceProtocol = APIService(),
         persistenceManager: PersistenceManager = PersistenceManager.shared,
         syncManager: SyncManager = .shared,
         networkManager: NetworkManager = .shared) {
        self.post = post
        self.apiService = apiService
        self.persistenceManager = persistenceManager
        self.syncManager = syncManager
        self.networkManager = networkManager
        
        Task {
            await checkFavoriteStatus()
        }
    }
    
    func fetchComments() async {
        do {
            comments = try await apiService.fetch(.comments(postId: post.id))
        } catch {
            self.error = error
        }
    }
    
    private func checkFavoriteStatus() async {
        isFavorite = (try? await persistenceManager.isPostFavorite(postId: post.id)) ?? false
    }
    
    func toggleFavorite() async {
        do {
            if isFavorite {
                try await persistenceManager.removeFavorite(postId: post.id)
                syncManager.addPendingUnfavorite(post.id)
            } else {
                try await persistenceManager.addFavorite(post)
                syncManager.addPendingFavorite(post.id)
            }
            isFavorite.toggle()
        } catch {
            self.error = error
        }
    }
} 
