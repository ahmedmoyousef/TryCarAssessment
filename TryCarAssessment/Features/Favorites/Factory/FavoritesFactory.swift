//
//  FavoritesFactory.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 24/02/2025.
//

import Foundation
import SwiftUI

enum FavoritesFactory {
    case favorite
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .favorite:
            FavoritesView()
        }
    }
}
