//
//  ProjectTimerAttributes.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import Foundation
import ActivityKit

struct ProjectTimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var endTime: Date?
        var startTime: Date?
        var projectName: String
        var isPaused: Bool
    }
    
    var timerType: String
}
