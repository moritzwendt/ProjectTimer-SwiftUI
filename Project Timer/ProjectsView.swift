//
//  ProjectsView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

struct ProjectsView: View {
    @Bindable var store: ProjectStore
    @State private var showAddSheet = false
    @State private var projectToDelete: Project?
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.projects.filter { !$0.isDeleted }) { project in
                    NavigationLink(destination: ProjectDetailView(store: store, project: project)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(project.title).font(.headline)
                                Text(project.createdAt.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(project.formattedTime)
                                .font(.subheadline.monospacedDigit().bold())
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        let activeProjects = store.projects.filter { !$0.isDeleted }
                        projectToDelete = activeProjects[index]
                        showDeleteAlert = true
                    }
                }
            }
            .navigationTitle("Projekte")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAddSheet = true } label: { Image(systemName: "plus") }
                }
            }
            .alert("Projekt Löschen?", isPresented: $showDeleteAlert, presenting: projectToDelete) { project in
                Button("Abbrechen", role: .cancel) { }
                Button("Löschen", role: .destructive) {
                    withAnimation { store.archiveProject(project) }
                }
            } message: { project in
                Text("Das Projekt '\(project.title)' wird in den Ordner 'Zuletzt gelöscht' verschoben.")
            }
            .sheet(isPresented: $showAddSheet) {
                AddProjectView(store: store)
            }
        }
    }
}
