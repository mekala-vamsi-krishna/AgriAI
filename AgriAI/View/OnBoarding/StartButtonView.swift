//
//  StartButtonView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/20/25.
//

import SwiftUI

struct StartButtonView: View {
    // MARK: Propertis
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    // MARK: Body
    var body: some View {
        Button(action: {
            isOnboarding = false
        }, label: {
            HStack(spacing: 8) {
                Text("Start")
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(Color.white, lineWidth: 1.25)
            )
        })
        .accentColor(Color.white)
    }
}

// MARK: Preview
#Preview {
    StartButtonView()
        .previewLayout(.sizeThatFits)
}
