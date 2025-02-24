//
//  Post.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import Foundation

struct Post: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
} 
