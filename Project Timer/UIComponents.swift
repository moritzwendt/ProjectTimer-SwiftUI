//
//  UIComponents.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

// MARK: - Glass Button (Liquid Style)
struct GlassButton: View {
    let title: String
    let icon: String?
    let color: Color
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.headline)
                }
                Text(title)
                    .font(.headline.bold())
            }
            .foregroundColor(isDisabled ? .secondary : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(.regularMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
            .overlay(
                Capsule()
                    .stroke(isDisabled ? Color.clear : color.opacity(0.2), lineWidth: 0.5)
            )
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
        .scaleEffect(isDisabled ? 1.0 : 0.98, anchor: .center) // Subtle press effect logic
    }
}

// MARK: - Glass Segment Control
struct GlassSegmentControl: View {
    @Binding var selection: Int
    let items: [String]
    @Namespace private var nspace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                Text(items[index])
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(selection == index ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selection = index
                        }
                    }
                    .background {
                        if selection == index {
                            Capsule()
                                .fill(.background)
                                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                                .matchedGeometryEffect(id: "active_seg", in: nspace)
                        }
                    }
            }
        }
        .padding(4)
        .background(.ultraThinMaterial, in: Capsule())
    }
}
