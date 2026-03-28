//
//  AddProjectsView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

struct AddProjectView: View {
    @Environment(\.dismiss) var dismiss
    var store: ProjectStore
    
    @State private var title = ""
    @State private var description = ""
    @State private var link = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informationen") {
                    TextField("Titel", text: $title)
                    TextField("Beschreibung", text: $description)
                    TextField("Link (Optional)", text: $link)
                }
            }
            .navigationTitle("Neues Projekt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button(action: {
                store.addProject(title: title, description: description, link: link)
                dismiss()
            }) {
                Image(systemName: "checkmark")
                    .bold()
            }
            .disabled(title.isEmpty)
        }
    }
}
