//
//  SyncManager.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation
import Combine
import os.log

@Observable
class SyncManager {
    static let shared = SyncManager()
    
    private var pendingFavorites: Set<Int> = []
    private var pendingUnfavorites: Set<Int> = []
    private let networkManager: NetworkManager
    private var cancellables = Set<AnyCancellable>()
    private let logger = Logger(subsystem: "com.trycar.sync", category: "SyncManager")
    
    private init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
        logger.debug("Initializing SyncManager")
        NotificationCenter.default.addObserver(self, selector: #selector(setupNetworkMonitoring), name: .networkStatusChanged, object: nil)
        loadPendingActions()
    }
    
    func addPendingFavorite(_ postId: Int) {
        logger.debug("Adding pending favorite for post: \(postId)")
        pendingFavorites.insert(postId)
        pendingUnfavorites.remove(postId)
        Task {
            await syncPendingActions()
        }
    }
    
    func addPendingUnfavorite(_ postId: Int) {
        logger.debug("Adding pending unfavorite for post: \(postId)")
        pendingUnfavorites.insert(postId)
        pendingFavorites.remove(postId)
        Task {
            await syncPendingActions()
        }
    }
    
    @objc
    private func setupNetworkMonitoring() {
        Task {
            await syncPendingActions()
        }
    }
    
    private func syncPendingActions() async {
        guard !pendingFavorites.isEmpty || !pendingUnfavorites.isEmpty else { return }
        guard networkManager.isConnected else {
            savePendingActions()
            logger.info("No network connection, delaying sync")
            return
        }
        
        logger.info("Starting sync of pending actions - Favorites: \(self.pendingFavorites.count), Unfavorites: \(self.pendingUnfavorites.count)")
        
        // Simulate API calls for syncing
        for postId in pendingFavorites {
            do {
                // Simulate API call
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                logger.debug("Successfully synced favorite for post: \(postId)")
            } catch {
                logger.error("Failed to sync favorite for post \(postId): \(error.localizedDescription)")
                continue
            }
        }
        
        for postId in pendingUnfavorites {
            do {
                // Simulate API call
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                logger.debug("Successfully synced unfavorite for post: \(postId)")
            } catch {
                logger.error("Failed to sync unfavorite for post \(postId): \(error.localizedDescription)")
                continue
            }
        }
        
        // Clear pending actions after successful sync
        let favoriteCount = pendingFavorites.count
        let unfavoriteCount = pendingUnfavorites.count
        
        pendingFavorites.removeAll()
        pendingUnfavorites.removeAll()
        savePendingActions()
        
        logger.info("Completed sync of pending actions - Synced \(favoriteCount) favorites and \(unfavoriteCount) unfavorites")
    }
    
    private func savePendingActions() {
        do {
            let data = PendingSyncData(
                favorites: Array(pendingFavorites),
                unfavorites: Array(pendingUnfavorites)
            )
            
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: "PendingSyncActions")
            logger.debug("Successfully saved pending actions to UserDefaults")
        } catch {
            logger.error("Failed to save pending actions: \(error.localizedDescription)")
        }
    }
    
    private func loadPendingActions() {
        logger.debug("Loading pending actions from UserDefaults")
        
        guard let data = UserDefaults.standard.data(forKey: "PendingSyncActions") else {
            logger.debug("No pending actions found in UserDefaults")
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode(PendingSyncData.self, from: data)
            pendingFavorites = Set(decoded.favorites)
            pendingUnfavorites = Set(decoded.unfavorites)
            logger.debug("Loaded pending actions - Favorites: \(self.pendingFavorites.count), Unfavorites: \(self.pendingUnfavorites.count)")
        } catch {
            logger.error("Failed to load pending actions: \(error.localizedDescription)")
        }
    }
    
    deinit {
        logger.debug("SyncManager is being deinitialized")
        NotificationCenter.default.removeObserver(self)
    }
}

private struct PendingSyncData: Codable {
    let favorites: [Int]
    let unfavorites: [Int]
} 
