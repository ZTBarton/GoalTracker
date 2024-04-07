//
//  Goal.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import Foundation
import SwiftData

@Model
final class Goal {
    var dateAdded: Date
    var lastView: Date
    var dueDate: Date
    var title: String
    var goalDescription: String?
    var status: String
    @Relationship(inverse: \GoalCategory.goals) var categories: [GoalCategory] = []
    @Relationship(deleteRule: .cascade) var journalEntries: [JournalEntry] = []
    var isComplete: Bool = false
    
    init(dateAdded: Date, lastView: Date, dueDate: Date, title: String, goalDescription: String?, status: String, categories: [GoalCategory], journalEntries: [JournalEntry]) {
        self.dateAdded = dateAdded
        self.lastView = lastView
        self.dueDate = dueDate
        self.title = title
        self.goalDescription = goalDescription
        self.status = status
        self.categories = categories
        self.journalEntries = journalEntries
    }
}
