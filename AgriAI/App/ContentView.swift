//
//  ContentView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: String = "house"

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                // Dynamic view based on selected tab
                Group {
                    switch selectedTab {
                    case "house":
                        DocumentUploadView()
                    case "leaf":
                        InsightsView()
                    case "person":
                        ProfileView()
                    default:
                        EmptyView()
                    }
                }

                Spacer()

                // Tab Bar
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}

