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
            List(deletedProjects, selection: $selection) { project in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.title)
                            .font(.headline)
                        Text("Archiviert am \(project.createdAt.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if editMode == .inactive {
                        Image(systemName: "archivebox")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 4)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.regularMaterial)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                )
                .listRowSeparator(.hidden)
                .tag(project.id)
            }
            .listStyle(.plain)
            .navigationTitle("Zuletzt gelöscht")
            .environment(\.editMode, $editMode)
            .safeAreaInset(edge: .bottom) {
                if editMode == .active {
                    selectionBottomBar
                        .transition(.move(edge: .bottom).combined(with: .opacity))
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
                    ContentUnavailableView("Papierkorb leer", systemImage: "trash.fill")
                }
            }
        }
    }
    
    private var selectionBottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation {
                        store.restoreProjects(ids: selection)
                        editMode = .inactive
                    }
                }) {
                    Label("Wiederherstellen", systemImage: "arrow.uturn.backward.circle.fill")
                        .font(.subheadline.bold())
                }
                .disabled(selection.isEmpty)
                
                Spacer()
                
                Button(role: .destructive, action: {
                    withAnimation {
                        store.deletePermanently(ids: selection)
                        editMode = .inactive
                    }
                }) {
                    Label("Löschen", systemImage: "trash.circle.fill")
                        .font(.subheadline.bold())
                }
                .disabled(selection.isEmpty)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(.ultraThinMaterial)
        }
    }
}
