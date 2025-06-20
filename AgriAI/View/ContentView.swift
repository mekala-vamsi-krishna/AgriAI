//
//  ContentView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: String = "house"
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?

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
                    case "person.circle":
                        ProfileView()
                    default:
                        if let image = capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        }
                    }
                }

                Spacer()

                // Tab Bar
                TabBar(selectedTab: $selectedTab)
                    .onChange(of: selectedTab) { newTab in
                        if newTab == "camera" {
                            isShowingCamera = true
                        }
                    }
            }

            // Fullscreen camera overlay
            if isShowingCamera {
                CameraView { image in
                    capturedImage = image
                    isShowingCamera = false
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}


// MARK: - Custom Tab Bar
struct TabBar: View {
    @Binding var selectedTab: String

    let tabs = ["house", "leaf", "camera", "person.circle"]

    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { icon in
                Spacer()
                TabBarItem(icon: icon, isSelected: selectedTab == icon) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        selectedTab = icon
                    }
                }
                Spacer()
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 12)
        .background(
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}


// MARK: - Tab Bar Item
struct TabBarItem: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(width: 44, height: 44)
                .background(isSelected ? Color.green : Color.clear)
                .clipShape(Circle())
                .shadow(color: isSelected ? Color.green.opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
    }
}

// MARK: - Blur Effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct InsightsView: View {
    var body: some View {
        Text("📊 Insights").font(.largeTitle).frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}

struct RotatingGearsView: View {
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

