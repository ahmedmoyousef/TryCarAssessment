//
//  TryCarAssessmentApp.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import SwiftUI

@main
struct TryCarAssessmentApp: App {
    let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                PostsView()
                    .tabItem {
                        Label("Posts", systemImage: "list.bullet")
                    }
                
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
            .environment(\.managedObjectContext, coreDataStack.viewContext)
        }
    }
} 
