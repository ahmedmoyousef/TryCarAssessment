//
//  Comment.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation

struct PostComment: Codable, Identifiable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
} 
