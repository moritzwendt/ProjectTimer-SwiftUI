//
//  SettingsView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var store: ProjectStore
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: DeletedProjectsView(store: store)) {
                        Label {
                            Text("Zuletzt gelöscht")
                        } icon: {
                            Image(systemName: "trash").foregroundColor(.red)
                        }
                    }
                } footer: {
                    Text("Projekte werden hier archiviert und können jederzeit wiederhergestellt werden.")
                }
                
                Section("App Info") {
                    LabeledContent("Version", value: "1.1.0")
                    LabeledContent("Engine", value: "SwiftUI 5.0")
                }
            }
            .navigationTitle("Einstellungen")
        }
    }
}
