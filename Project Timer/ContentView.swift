//
//  ContentView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 27.03.26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProjectsView()
                .tabItem {
                    Label("Projekte", systemImage: "folder.fill")
                }
                .tag(0)
            
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "stopwatch.fill")
                }
                .tag(1)
            
            SettingsView()
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
