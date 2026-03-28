//
//  TimerView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "stopwatch")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                    .padding()
                
                Text("Kein aktiver Timer")
                    .font(.headline)
            }
            .navigationTitle("Timer")
        }
    }
}

#Preview {
    TimerView()
}
