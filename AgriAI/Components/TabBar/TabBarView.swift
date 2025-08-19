//
//  TabBarView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 8/20/25.
//

import SwiftUI


// MARK: - Tab Bar Item
struct TabBarItem: View {
    let normalIcon: String
    let selectedIcon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? selectedIcon : normalIcon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(isSelected ? .green : .black.opacity(0.7))
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Tab Bar Shape with Semi-circle Cutout
struct TabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius: CGFloat = 45   // radius of the half-circle
        let centerX = rect.midX
        
        // Start from top-left
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Left edge
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        // Bottom edge
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        // Right edge
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // Move to start of cutout (right side of semicircle)
        path.addLine(to: CGPoint(x: centerX + radius, y: 0))
        
        // Draw semi-circle dipping inside
        path.addArc(
            center: CGPoint(x: centerX, y: 0),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        // Continue to left edge
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
}



// MARK: - Custom Tab Bar
struct TabBarView: View {
    @Binding var selectedTab: String
    
    // Use dictionary: normalIcon → selectedIcon
    let leftTabs: [(normal: String, selected: String)] = [
        ("house", "house.fill")
    ]
    let rightTabs: [(normal: String, selected: String)] = [
        ("person", "person.fill")
    ]
    let centerIcon = "leaf"
    
    var body: some View {
        ZStack {
            // Background with semi-circle cutout in middle
            TabBarShape()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: -2)
                .ignoresSafeArea(edges: .bottom)
            
            HStack {
                // Left side tabs
                ForEach(leftTabs, id: \.normal) { tab in
                    Spacer()
                    TabBarItem(
                        normalIcon: tab.normal,
                        selectedIcon: tab.selected,
                        isSelected: selectedTab == tab.normal || selectedTab == tab.selected
                    ) {
                        withAnimation(.spring()) {
                            selectedTab = tab.normal
                        }
                    }
                    Spacer()
                }
                
                // Right side tabs
                ForEach(rightTabs, id: \.normal) { tab in
                    Spacer()
                    TabBarItem(
                        normalIcon: tab.normal,
                        selectedIcon: tab.selected,
                        isSelected: selectedTab == tab.normal || selectedTab == tab.selected
                    ) {
                        withAnimation(.spring()) {
                            selectedTab = tab.normal
                        }
                    }
                    Spacer()
                }
            }
            
            // Floating leaf in center
            VStack {
                Button(action: {
                    withAnimation(.spring()) {
                        selectedTab = centerIcon
                    }
                }) {
                    Image(systemName: centerIcon)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(colors: [.green, .teal],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                        )
                        .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 6)
                }
                .offset(y: -30)
            }
        }
        .frame(height: 70)
    }
}

#Preview {
    @Previewable @State var selectedTab: String = "house.fill"
    TabBarView(selectedTab: $selectedTab)
}
