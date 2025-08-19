//
//  RotatingGearsLoadingView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 8/20/25.
//

import SwiftUI

struct RotatingGearsLoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: -10) {
            Image(systemName: "gearshape")
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: isAnimating)

            Image(systemName: "gearshape.fill")
                .rotationEffect(.degrees(isAnimating ? -360 : 0))
                .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
        .foregroundColor(.white)
    }
}

#Preview {
    RotatingGearsLoadingView()
}
