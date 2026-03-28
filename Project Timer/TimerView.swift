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
                HStack {
                    Text("Timer")
                        .font(.largeTitle.bold())
                    Spacer()
                    projectPickerHeader
                }
                .padding()

                GlassSegmentControl(selection: $timerMode, items: ["Stoppuhr", "Timer"])
                    .padding(.horizontal)
                    .disabled(isRunning)

                Spacer()

                ZStack {
                    if timerMode == 1 {
                        if isRunning || elapsedTime > 0 {
                            progressRing
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .scale(scale: 0.9)),
                                    removal: .opacity.combined(with: .scale(scale: 1.1))
                                ))
                        }
                        
                        if !isRunning && elapsedTime == 0 {
                            wheelPicker
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        } else {
                            timeDisplay(size: 48)
                        }
                    } else {
                        timeDisplay(size: 60)
                    }
                }
                .frame(height: 320)
                .animation(.easeInOut(duration: 0.4), value: isRunning)
                .animation(.easeInOut(duration: 0.4), value: timerMode)

                Spacer()

                VStack(spacing: 14) {
                    if isRunning {
                        GlassButton(title: "Pause", icon: "pause.fill", color: .orange) {
                            withAnimation { isRunning = false }
                        }
                        GlassButton(title: "Session beenden", icon: "checkmark", color: .green) {
                            endSession()
                        }
                    } else {
                        GlassButton(
                            title: "Start",
                            icon: "play.fill",
                            color: .blue,
                            isDisabled: selectedProjectID == nil || (timerMode == 1 && hours == 0 && minutes == 0)
                        ) {
                            startSession()
                        }
                        
                        if elapsedTime > 0 {
                            GlassButton(title: "Session beenden", icon: "checkmark", color: .green) {
                                endSession()
                            }
                        } else {
                            Color.clear.frame(height: 58)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .onReceive(tickTimer) { _ in updateLogic() }
        }
    }

    private func timeDisplay(size: CGFloat) -> some View {
        Text(formatToTime(elapsedTime))
            .font(.system(size: size, weight: .medium, design: .monospaced))
            .monospacedDigit()
            .minimumScaleFactor(0.5)
            .padding(.horizontal, 40)
            .contentTransition(.numericText())
    }

    private var progressRing: some View {
        Circle()
            .stroke(Color.primary.opacity(0.06), lineWidth: 10)
            .frame(width: 270, height: 270)
            .overlay {
                if initialTimerSeconds > 0 {
                    Circle()
                        .trim(from: 0, to: elapsedTime / initialTimerSeconds)
                        .stroke(
                            LinearGradient(colors: [.accentColor, .accentColor.opacity(0.7)], startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                }
            }
    }

    private var projectPickerHeader: some View {
        Menu {
            Picker("Projekt", selection: $selectedProjectID) {
                Text("Wählen").tag(UUID?.none)
                ForEach(store.projects.filter { !$0.isDeleted }) { p in
                    Text(p.title).tag(UUID?.some(p.id))
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selectedProject?.title ?? "Projekt wählen")
                    .fontWeight(.semibold)
                Image(systemName: "chevron.right")
                    .font(.caption2.bold())
            }
            .foregroundColor(.accentColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }

    private var wheelPicker: some View {
        HStack(spacing: 0) {
            Picker("h", selection: $hours) { ForEach(0..<24) { Text("\($0)h") } }.pickerStyle(.wheel).frame(width: 75)
            Picker("m", selection: $minutes) { ForEach(0..<60) { Text("\($0)m") } }.pickerStyle(.wheel).frame(width: 75)
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
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { isRunning = true }
    }

    private func endSession() {
        if let id = selectedProjectID {
            let tracked = timerMode == 0 ? elapsedTime : (initialTimerSeconds - elapsedTime)
            if tracked > 1 { store.addTime(to: id, seconds: tracked) }
        }
        withAnimation(.easeOut) {
            isRunning = false
            elapsedTime = 0
        }
    }

    private func formatToTime(_ seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
