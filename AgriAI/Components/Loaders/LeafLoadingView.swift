//
//  LeafLoadingView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 8/20/25.
//

import SwiftUI

struct LeafLoadingView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .foregroundColor(Color.green.opacity(0.3))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                        .scaleEffect(animate ? 1.2 : 0.8)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                        .animation(
                            .easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true),
                            value: animate
                        )
                }
                
                Text("Analyzing Soil & Crops…")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    LeafLoadingView()
}
