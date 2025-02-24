//
//  Endpoint.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation

enum Endpoint {
    case posts
    case comments(postId: Int)
    
    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .comments(let postId):
            return "/posts/\(postId)/comments"
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = path
        return components.url
    }
} 
