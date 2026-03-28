//
//  UIComponents.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

// MARK: - Liquid Glass Button
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
                }
                Text(title)
            }
            .font(.headline.bold())
            .foregroundColor(isDisabled ? .secondary : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(.regularMaterial, in: Capsule())
            .overlay(Capsule().stroke(color.opacity(0.1), lineWidth: 0.5))
            .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

// MARK: - Liquid Glass Row
struct GlassListRow<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.1), lineWidth: 0.5))
            .padding(.horizontal)
            .padding(.vertical, 4)
    }
}

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
