//
//  DeletedProjectsView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

struct DeletedProjectsView: View {
    @Bindable var store: ProjectStore
    @State private var selection = Set<UUID>()
    @State private var editMode: EditMode = .inactive
    
    var deletedProjects: [Project] {
        store.projects.filter { $0.isDeleted }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(deletedProjects) { project in
                        GlassListRow {
                            HStack {
                                if editMode == .active {
                                    Image(systemName: selection.contains(project.id) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selection.contains(project.id) ? .accentColor : .secondary)
                                        .font(.title3)
                                        .padding(.trailing, 8)
                                        .onTapGesture {
                                            if selection.contains(project.id) {
                                                selection.remove(project.id)
                                            } else {
                                                selection.insert(project.id)
                                            }
                                        }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(project.title)
                                        .font(.headline)
                                    Text("Gelöscht am \(project.createdAt.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if editMode == .active {
                                if selection.contains(project.id) {
                                    selection.remove(project.id)
                                } else {
                                    selection.insert(project.id)
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Zuletzt gelöscht")
            .safeAreaInset(edge: .bottom) {
                if editMode == .active {
                    glassBottomBar
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(editMode == .active ? "Fertig" : "Auswählen") {
                        withAnimation(.spring()) {
                            editMode = (editMode == .active) ? .inactive : .active
                            selection.removeAll()
                        }
                    }
                }
            }
            .overlay {
                if deletedProjects.isEmpty {
                    ContentUnavailableView("Keine Projekte", systemImage: "trash")
                }
            }
        }
    }
    
    private var glassBottomBar: some View {
        HStack(spacing: 20) {
            Button("Wiederherstellen") {
                withAnimation {
                    store.restoreProjects(ids: selection)
                    editMode = .inactive
                }
            }
            .fontWeight(.semibold)
            .disabled(selection.isEmpty)
            
            Spacer()
            
            Button("Löschen", role: .destructive) {
                withAnimation {
                    store.deletePermanently(ids: selection)
                    editMode = .inactive
                }
            }
            .fontWeight(.semibold)
            .disabled(selection.isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(.regularMaterial) // Liquid Glass Bottom Bar
        .overlay(Divider(), alignment: .top)
    }
}
