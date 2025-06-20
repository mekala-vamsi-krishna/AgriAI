//
//  ProfileView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/20/25.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Profile Image
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("ColorLimeDark"))
                .padding(.top, 40)

            // Name
            Text("Vamsi Krishna")
                .font(.title2)
                .fontWeight(.semibold)

            // Email
            Text("vamsi@example.com")
                .font(.subheadline)
                .foregroundColor(.gray)

            Divider().padding(.horizontal)

            // Settings Section
            VStack(spacing: 16) {
                ProfileRow(icon: "gearshape", title: "Settings")
                ProfileRow(icon: "doc.text", title: "My Reports")
                ProfileRow(icon: "questionmark.circle", title: "Help & Support")
                ProfileRow(icon: "rectangle.portrait.and.arrow.forward", title: "Log Out")
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(Color("ColorLimeDark"))
                .frame(width: 24, height: 24)

            Text(title)
                .foregroundColor(.primary)
                .font(.body)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}


#Preview {
    ProfileView()
}
