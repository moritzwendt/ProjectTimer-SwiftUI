//
//  ProjectDetailView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

struct ProjectDetailView: View {
    @Bindable var store: ProjectStore
    @State var project: Project
    @State private var showEditSheet = false
    
    var body: some View {
        List {
            Section("Details") {
                LabeledContent("Titel", value: project.title)
                if !project.description.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Beschreibung").font(.caption).foregroundColor(.secondary)
                        Text(project.description)
                    }
                }
                if !project.link.isEmpty {
                    Link(destination: URL(string: project.link) ?? URL(string: "https://google.com")!) {
                        Label(project.link, systemImage: "link")
                            .lineLimit(1)
                    }
                }
            }
            
            Section("Zeit & Datum") {
                LabeledContent("Gesamtzeit", value: project.formattedTime)
                LabeledContent("Erstellt am", value: project.createdAt.formatted(date: .long, time: .omitted))
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Bearbeiten") { showEditSheet = true }
        }
        .sheet(isPresented: $showEditSheet) {
            EditProjectSheet(store: store, project: $project)
        }
    }
}

struct EditProjectSheet: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: ProjectStore
    @Binding var project: Project
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Titel", text: $project.title)
                TextField("Beschreibung", text: $project.description)
                TextField("Link", text: $project.link)
            }
            .navigationTitle("Projekt bearbeiten")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") {
                        store.updateProject(project)
                        dismiss()
                    }
                }
            }
        }
    }
}
