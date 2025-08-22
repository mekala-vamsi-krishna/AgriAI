//
//  DestinationView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/12/25.
//

import SwiftUI

// MARK: - Results Screen
struct ResultsView: View {
    let recommendations: [Recommendation]
    
    var body: some View {
        List(recommendations) { rec in
            VStack(alignment: .leading, spacing: 6) {
                Text("Crop: \(rec.crop)")
                    .font(.headline)
                Text("Fertilizer: \(rec.fertilizer)")
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Recommendations")
    }
}


#Preview {
    ResultsView(recommendations: [])
}
