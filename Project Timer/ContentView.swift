//
//  ContentView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 27.03.26.
//

import SwiftUI

struct ContentView: View {
    @State private var store = ProjectStore()
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProjectsView(store: store)
                .tabItem {
                    Label("Projekte", systemImage: "folder.fill")
                }
                .tag(0)
            
            TimerView(store: store)
                .tabItem {
                    Label("Timer", systemImage: "stopwatch.fill")
                }
                .tag(1)
            
            SettingsView(store: store)
                .tabItem {
                    Label("Einstellungen", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
