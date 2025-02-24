//
//  FavoritesViewModel.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation
import CoreData
import SwiftUI

@Observable @MainActor
class FavoritesViewModel: ObservableObject {
    private(set) var favoritePosts: [Post] = []
    private(set) var isLoading = false
    
    var showError = false
    var errorMessage: String?
    var paths: [PostsPath] = []
    
    private let persistenceManager: PersistenceManager
    private var loadingTask: Task<Void, Never>?
    
    
    init(persistenceManager: PersistenceManager = PersistenceManager.shared) {
        self.persistenceManager = persistenceManager
    }
    
    func loadFavorites() async {
        // Cancel any existing loading task
        loadingTask?.cancel()
        
        loadingTask = Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                guard !Task.isCancelled else { return }
                favoritePosts = try await persistenceManager.fetchFavorites()
            } catch {
                handleError(error)
            }
        }
        
        await loadingTask?.value
    }
    
    func removeFavorite(post: Post) {
        Task {
            do {
                try await persistenceManager.removeFavorite(postId: post.id)
                // Optimistically remove from the UI
                favoritePosts.removeAll { $0.id == post.id }
                // Then refresh the list
                await loadFavorites()
            } catch {
                handleError(error)
            }
        }
    }
    
    func didSelect(post: Post) {
        paths.append(.postDetail(post))
    }
    
    private func handleError(_ error: Error) {
        if let error = error as? URLError, error.code == .cancelled {
            return // Ignore cancellation errors
        }
        
        errorMessage = error.localizedDescription
        showError = true
    }
}

// MARK: - Preview Helper
extension FavoritesViewModel {
    static var preview: FavoritesViewModel {
        let viewModel = FavoritesViewModel()
        viewModel.favoritePosts = [
            Post(id: 1, userId: 1, title: "Sample Post", body: "This is a sample post body"),
            Post(id: 2, userId: 1, title: "Another Post", body: "This is another sample post body")
        ]
        return viewModel
    }
} 
