//
//  TimerView.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import SwiftUI
import Combine

struct TimerView: View {
    @Bindable var store: ProjectStore
    
    @State private var selectedProjectID: UUID?
    @State private var timerMode: Int = 0
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var elapsedTime: TimeInterval = 0
    @State private var initialTimerSeconds: TimeInterval = 1
    @State private var isRunning = false
    
    private let tickTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var selectedProject: Project? {
        store.projects.first(where: { $0.id == selectedProjectID })
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header: Titel & Picker in einer Zeile
                HStack(alignment: .firstTextBaseline) {
                    Text("Timer")
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    projectPickerHeader
                }
                .padding(.horizontal)
                .padding(.top)

                GlassSegmentControl(selection: $timerMode, items: ["Stoppuhr", "Timer"])
                    .padding()
                    .disabled(isRunning)

                Spacer()

                // Stable Display Area
                ZStack {
                    if timerMode == 1 {
                        // Timer Modus
                        if isRunning || elapsedTime > 0 {
                            progressRing
                                .transition(.scale(0.9).combined(with: .opacity))
                        }
                        
                        if !isRunning && elapsedTime == 0 {
                            wheelPicker
                                .transition(.opacity)
                        } else {
                            timeText(size: 48)
                        }
                    } else {
                        // Stoppuhr Modus
                        timeText(size: 60)
                            .transition(.opacity.combined(with: .scale(1.1)))
                    }
                }
                .frame(height: 300)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isRunning)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: timerMode)

                Spacer()

                // Control Buttons
                VStack(spacing: 12) {
                    if isRunning {
                        GlassButton(title: "Pause", icon: "pause.fill", color: .orange) { isRunning = false }
                        GlassButton(title: "Session beenden", icon: "checkmark", color: .green) { endSession() }
                    } else {
                        GlassButton(title: "Start", icon: "play.fill", color: .blue, isDisabled: selectedProjectID == nil || (timerMode == 1 && hours == 0 && minutes == 0)) {
                            startSession()
                        }
                        
                        if elapsedTime > 0 {
                            GlassButton(title: "Session beenden", icon: "checkmark", color: .green) { endSession() }
                        } else {
                            Color.clear.frame(height: 56) // Placeholder
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .onReceive(tickTimer) { _ in updateLogic() }
        }
    }

    private var projectPickerHeader: some View {
        Menu {
            Picker("Projekt", selection: $selectedProjectID) {
                Text("Projekt wählen").tag(UUID?.none)
                ForEach(store.projects.filter { !$0.isDeleted }) { p in
                    Text(p.title).tag(UUID?.some(p.id))
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text(selectedProject?.title ?? "Wählen")
                    .fontWeight(.medium)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption2.bold())
            }
            .foregroundColor(.accentColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }

    private func timeText(size: CGFloat) -> some View {
        Text(formatToTime(elapsedTime))
            .font(.system(size: size, weight: .medium, design: .monospaced))
            .monospacedDigit()
            .minimumScaleFactor(0.5)
            .contentTransition(.numericText())
    }

    private var progressRing: some View {
        Circle()
            .stroke(Color.primary.opacity(0.05), lineWidth: 10)
            .frame(width: 270, height: 270)
            .overlay {
                Circle()
                    .trim(from: 0, to: elapsedTime / initialTimerSeconds)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
    }

    private var wheelPicker: some View {
        HStack(spacing: 0) {
            Picker("h", selection: $hours) { ForEach(0..<24) { Text("\($0)h") } }.pickerStyle(.wheel).frame(width: 70)
            Picker("m", selection: $minutes) { ForEach(0..<60) { Text("\($0)m") } }.pickerStyle(.wheel).frame(width: 70)
        }
    }

    private func updateLogic() {
        guard isRunning else { return }
        if timerMode == 0 { elapsedTime += 0.1 } else {
            if elapsedTime > 0 { elapsedTime -= 0.1 } else { endSession() }
        }
    }

    private func startSession() {
        if timerMode == 1 && elapsedTime == 0 {
            initialTimerSeconds = TimeInterval(hours * 3600 + minutes * 60)
            elapsedTime = initialTimerSeconds
        }
        withAnimation { isRunning = true }
    }

    private func endSession() {
        if let id = selectedProjectID {
            let tracked = timerMode == 0 ? elapsedTime : (initialTimerSeconds - elapsedTime)
            if tracked > 1 { store.addTime(to: id, seconds: tracked) }
        }
        isRunning = false
        elapsedTime = 0
    }

    private func formatToTime(_ seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
