//
//  LoadingProgressViewModifier.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import SwiftUI

struct LoadingProgressViewModifier: ViewModifier {
    
    var isShowing: Bool
    
    private struct LoadingProgressView: View {
        
        var isShowing: Bool
        
        var body: some View {
            
            if isShowing {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.5))
            }
            
        }
        
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(LoadingProgressView(isShowing: isShowing))
    }
    
}

extension View {
    
    func isLoading(_ isLoading: Bool) -> some View {
        modifier(LoadingProgressViewModifier(isShowing: isLoading))
    }
    
}

struct LoadingProgressViewModifier_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            Text("Test View")
                .frame(maxWidth: 300, maxHeight: 300)
                .isLoading(true)
            
            Text("Test View")
                .frame(maxWidth: 300, maxHeight: 300)
                .isLoading(false)
            
        }
        .previewLayout(.sizeThatFits)
        
    }
    
}
