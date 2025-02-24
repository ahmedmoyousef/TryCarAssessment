//
//  PersistenceManager.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }
    
    /// Saves a list of posts to CoreData, avoiding duplicates.
    func savePosts(_ posts: [Post]) async throws {
        try await context.perform {
            let existingPosts = try self.fetchExistingPostIDs()
            for post in posts where !existingPosts.contains(post.id) {
                let entity = PostEntity(context: self.context)
                entity.id = Int64(post.id)
                entity.userId = Int64(post.userId)
                entity.title = post.title
                entity.body = post.body
                entity.isFavorite = false
            }
            if self.context.hasChanges {
                try self.context.save()
            }
        }
    }
    
    /// Fetches all posts from CoreData.
    func fetchPosts() async throws -> [Post] {
        try await context.perform {
            let request = PostEntity.fetchRequest()
            let entities = try self.context.fetch(request)
            return entities.map { self.mapToPost($0) }
        }
    }
    
    /// Fetches only favorite posts.
    func fetchFavorites() async throws -> [Post] {
        try await context.perform {
            let request = PostEntity.fetchRequest()
            request.predicate = NSPredicate(format: "isFavorite == YES")
            let entities = try self.context.fetch(request)
            return entities.map { self.mapToPost($0) }
        }
    }
    
    /// Removes a post from favorites.
    func removeFavorite(postId: Int) async throws {
        try await context.perform {
            if let entity = try self.fetchPostEntity(by: postId) {
                entity.isFavorite = false
                try self.context.save()
            }
        }
    }
    
    /// Adds a post to favorites.
    func addFavorite(_ post: Post) async throws {
        try await context.perform {
            let entity = try self.fetchOrCreatePostEntity(for: post)
            entity.isFavorite = true
            try self.context.save()
        }
    }
    
    /// Checks if a post is marked as favorite.
    func isPostFavorite(postId: Int) async throws -> Bool {
        try await context.perform {
            let request = PostEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d AND isFavorite == YES", postId)
            return try self.context.count(for: request) > 0
        }
    }
}

extension PersistenceManager {
    /// Fetches existing post IDs to prevent duplicates.
    private func fetchExistingPostIDs() throws -> Set<Int> {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.propertiesToFetch = ["id"]
        
        let entities = try context.fetch(request)
        return Set(entities.map { Int($0.id) })
    }
    
    /// Fetches a `PostEntity` by ID.
    private func fetchPostEntity(by postId: Int) throws -> PostEntity? {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", postId)
        return try context.fetch(request).first
    }
    
    /// Fetches or creates a `PostEntity` for a given `Post`.
    private func fetchOrCreatePostEntity(for post: Post) throws -> PostEntity {
        if let entity = try fetchPostEntity(by: post.id) {
            return entity
        } else {
            let entity = PostEntity(context: self.context)
            entity.id = Int64(post.id)
            entity.userId = Int64(post.userId)
            entity.title = post.title
            entity.body = post.body
            return entity
        }
    }
    
    /// Maps `PostEntity` to `Post` model.
    private func mapToPost(_ entity: PostEntity) -> Post {
        return Post(
            id: Int(entity.id),
            userId: Int(entity.userId),
            title: entity.title ?? "",
            body: entity.body ?? ""
        )
    }
}
