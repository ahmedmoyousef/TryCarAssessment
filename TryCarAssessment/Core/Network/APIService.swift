//
//  APIServiceProtocol.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation
import Combine
import os.log

protocol APIServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

class APIService: APIServiceProtocol {
    private let session: URLSession
    private let logger = Logger(subsystem: "com.yourapp.network", category: "APIService")
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        // Log the request
        guard let url = endpoint.url else {
            logger.error("Invalid URL for endpoint: \(endpoint.path)")
            throw URLError(.badURL)
        }
        
        logger.debug("Sending request to: \(url.absoluteString)")
        
        let (data, response) = try await session.data(from: url)
        
        // Log the response
        if let httpResponse = response as? HTTPURLResponse {
            logger.debug("Received response with status code: \(httpResponse.statusCode)")
        } else {
            logger.error("Invalid response received")
            throw URLError(.badServerResponse)
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            logger.error("Server returned an error: \(String(describing: response))")
            throw URLError(.badServerResponse)
        }
        
        // Log the response data (optional, for debugging purposes)
        if let responseString = String(data: data, encoding: .utf8) {
            logger.debug("Response data: \(responseString)")
        }
        
        // Decode and return the response
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            logger.debug("Successfully decoded response to type: \(String(describing: T.self))")
            return decodedResponse
        } catch {
            logger.error("Failed to decode response: \(error.localizedDescription)")
            throw error
        }
    }
}
