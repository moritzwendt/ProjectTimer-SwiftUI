//
//  Item.swift
//  Project Timer
//
//  Created by Moritz Wendt on 27.03.26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
