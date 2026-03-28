//
//  ProjectsView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

struct ProjectsView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Deine Projekte erscheinen hier")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Projekte")
        }
    }
}

#Preview {
    ProjectsView()
}
