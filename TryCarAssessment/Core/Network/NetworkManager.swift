//
//  NetworkManager.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation
import Network
import Combine
import os.log

// MARK: - Network Status Notification
extension Notification.Name {
    static let networkStatusChanged = Notification.Name("NetworkStatusChanged")
}

struct NetworkStatusUserInfo {
    static let statusKey = "networkStatus"
}

@Observable
class NetworkManager {
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let logger = Logger(subsystem: "com.trycar.network", category: "NetworkManager")
    
    var isConnected: Bool = false {
        didSet {
            logger.debug("Network connection status changed: \(self.isConnected ? "Connected" : "Disconnected")")
            notifyNetworkStatusChange()
        }
    }
    
    private init() {
        logger.debug("Initializing NetworkManager")
        startMonitoring()
    }
    
    func startMonitoring() {
        logger.info("Starting network monitoring")
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let status = path.status
            let isExpensive = path.isExpensive
            let interfaces = path.availableInterfaces.map { $0.type }
            
            logger.debug("""
                Network path changed:
                Status: \(String(describing: status))
                Expensive: \(isExpensive)
                Interfaces: \(interfaces)
                """
            )
            
            DispatchQueue.main.async {
                self.isConnected = status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
        logger.info("Network monitoring started on queue: \(self.queue.label)")
    }
    
    private func notifyNetworkStatusChange() {
        logger.debug("Posting network status notification: \(self.isConnected ? "Connected" : "Disconnected")")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .networkStatusChanged,
                object: self,
                userInfo: [NetworkStatusUserInfo.statusKey: self.isConnected]
            )
        }
    }
    
    deinit {
        logger.debug("NetworkManager is being deinitialized")
        monitor.cancel()
    }
}


