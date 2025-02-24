//
//  LoadingViewModifier.swift
//  TryCarAssessment
//
//  Created by Ahmed Mohamed Yousef on 23/02/2025.
//

import SwiftUI

struct LoadingViewModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
            
            if isLoading {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
            }
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
} 