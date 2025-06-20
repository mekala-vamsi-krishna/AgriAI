//
//  AgriAIApp.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/3/25.
//

import SwiftUI

@main
struct AgriAIApp: App {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnBoardingView()
            } else {
                ContentView()
//                DocumentUploadView()
            }
        }
    }
}
