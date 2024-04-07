//
//  Category.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import Foundation
import SwiftData

@Model
final class GoalCategory {
    var dateAdded: Date
    var lastUsed: Date
    @Attribute(.unique) var title: String
    
    var goals: [Goal] = []
    
    init(dateAdded: Date, lastUsed: Date, title: String) {
        self.dateAdded = dateAdded
        self.lastUsed = lastUsed
        self.title = title
    }
}
