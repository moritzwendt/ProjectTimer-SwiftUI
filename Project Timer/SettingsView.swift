//
//  SettingsView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Allgemein") {
                    Label("Profil", systemImage: "person.circle")
                    Label("Benachrichtigungen", systemImage: "bell")
                }
                
                Section("Info") {
                    Text("Version 1.0.0")
                }
            }
            .navigationTitle("Einstellungen")
        }
    }
}

#Preview {
    SettingsView()
}
