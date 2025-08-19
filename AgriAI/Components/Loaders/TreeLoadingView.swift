//
//  TreeLoadingView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 8/20/25.
//

import SwiftUI

struct TreeLoadingView: View {
    @State private var sway = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "tree.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(
                        LinearGradient(colors: [.green, .teal],
                                       startPoint: .top,
                                       endPoint: .bottom)
                    )
                    .rotationEffect(.degrees(sway ? 5 : -5), anchor: .bottom) // sway left-right
                    .scaleEffect(sway ? 1.05 : 0.95) // slight breathing
                    .animation(
                        .easeInOut(duration: 0.7)
                        .repeatForever(autoreverses: true),
                        value: sway
                    )
                
                Text("Whispering with the wind…")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            sway = true
        }
    }
}

#Preview {
    TreeLoadingView()
}
