//
//  Project.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//

import Foundation

struct Project: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var link: String
    var createdAt: Date
    var totalTrackedTime: TimeInterval
    var isDeleted: Bool = false
    
    var formattedTime: String {
        let minutes = totalTrackedTime / 60
        if minutes < 120 {
            return "\(Int(minutes)) Min"
        } else {
            let hours = minutes / 60
            return String(format: "%.1fh", hours)
        }
    }
}
