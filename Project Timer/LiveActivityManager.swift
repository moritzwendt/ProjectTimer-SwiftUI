//
//  LiveActivityManager.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import Foundation
import ActivityKit

class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var activity: Activity<ProjectTimerAttributes>?
    
    func startActivity(projectName: String, type: String, duration: TimeInterval? = nil) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = ProjectTimerAttributes(timerType: type)
        let state: ProjectTimerAttributes.ContentState
        
        if type == "Timer", let duration = duration {
            state = ProjectTimerAttributes.ContentState(
                endTime: Date().addingTimeInterval(duration),
                startTime: nil,
                projectName: projectName,
                isPaused: false
            )
        } else {
            state = ProjectTimerAttributes.ContentState(
                endTime: nil,
                startTime: Date(),
                projectName: projectName,
                isPaused: false
            )
        }
        
        do {
            activity = try Activity.request(attributes: attributes, content: .init(state: state, staleDate: nil))
        } catch {
            print("Fehler beim Starten der Live Activity: \(error.localizedDescription)")
        }
    }
    
    func stopActivity() {
        Task {
            for activity in Activity<ProjectTimerAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}
