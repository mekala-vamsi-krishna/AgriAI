//
//  DestinationView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/12/25.
//

import SwiftUI

struct DestinationView: View {
    @Environment(\.dismiss) private var dismiss
    var text: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)

                    Text("Document Processing Complete!")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("Your document has been successfully processed. Below is the extracted content:")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Divider()

                    Text(text)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    Spacer(minLength: 30)

                    Button("Continue") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.green)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                .padding()
                .navigationTitle("Success")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    DestinationView(text: "")
}
