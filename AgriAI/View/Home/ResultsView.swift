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
    
    // Adaptive grid for unsymmetrical layout
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    @State private var animate = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(recommendations) { rec in
                    
                    // Parameter Card
                    CardView(title: rec.parameter, content: "")
                        .foregroundColor(.green)
                        .font(.headline)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: animate)
                    
                    // Crops Card
                    CardView(title: "🌾 Crops", content: rec.crops.joined(separator: ", "))
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: animate)
                    
                    // Fertilizer Card
                    CardView(title: "🧪 Fertilizer", content: rec.fertilizerAdvice)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: animate)
                    
                    // Irrigation Card
                    CardView(title: "💧 Irrigation", content: rec.irrigation)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: animate)
                    
                    // Disease Risk Card
                    CardView(title: "🦠 Disease Risk", content: rec.diseaseRisk)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5), value: animate)
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea()) // ✅ fixes white strip
        .onAppear {
            animate = true
        }
        .navigationTitle("Recommendations")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Reusable Card View
struct CardView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            if !content.isEmpty {
                Text(content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(.systemGray6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 4)
    }
}




#Preview {
    ResultsView(recommendations: [])
}
