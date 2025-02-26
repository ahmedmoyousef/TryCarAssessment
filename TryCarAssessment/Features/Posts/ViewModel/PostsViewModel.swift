//
//  PostsViewModel.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation
import Combine

@Observable
class PostsViewModel {
    private(set) var posts: [Post] = []
    private(set) var error: Error?
    private(set) var isLoading: Bool = false
    
    private let apiService: APIServiceProtocol
    private let persistenceManager: PersistenceManagerProtocol
    private let networkManager: NetworkManager
    var isConnected: Bool {
        return networkManager.isConnected
    }
    var paths: [PostsPath] = []
    
    init(apiService: APIServiceProtocol = APIService(),
         persistenceManager:PersistenceManagerProtocol = PersistenceManager.shared,
         networkManager: NetworkManager = .shared
    ) {
        self.apiService = apiService
        self.persistenceManager = persistenceManager
        self.networkManager = networkManager
    }
    
    func fetchPosts(forceRefresh: Bool = false) async {
        guard posts.isEmpty || forceRefresh else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            if networkManager.isConnected {
                // Fetch from API and cache
                let fetchedPosts: [Post] = try await apiService.fetch(.posts)
                posts = fetchedPosts
                try await persistenceManager.savePosts(fetchedPosts)
            } else {
                // Load from cache
                posts = try await persistenceManager.fetchPosts()
            }
        } catch {
            self.error = error
            // Try to load from cache if API fails
            if networkManager.isConnected {
                posts = (try? await persistenceManager.fetchPosts()) ?? []
            }
        }
    }
    
    func didSelect(post: Post) {
        paths.append(.postDetail(post))
    }
}
