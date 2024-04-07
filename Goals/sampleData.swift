//
//  mockData.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import Foundation
import SwiftData

let sampleCategories = [
    GoalCategory(dateAdded: Date(), lastUsed: Date(), title: "Work"),
    GoalCategory(dateAdded: Date(), lastUsed: Date(), title: "School"),
    GoalCategory(dateAdded: Date(), lastUsed: Date(), title: "Personal"),
    GoalCategory(dateAdded: Date(), lastUsed: Date(), title: "Spiritual")
]

let sampleGoals: [SampleGoal] = [
    SampleGoal(goal: Goal(dateAdded: Date(), lastView: Date(), dueDate: Date(), title: "Get SAA Certification", goalDescription: "This is to help with career development", status: Constants.StatusStrings[1], categories: [], journalEntries: [JournalEntry(dateCreated: Date(), title: "Started the Udemy Course", body: "I think I will need to dedicate at least 2 hours a week to finish this in a reasonable amount of time")])
                    , categories:
                    ["Work"]),
    SampleGoal(goal: Goal(dateAdded: Date(), lastView: Date(), dueDate: Date(), title: "Finish BOM during 2024", goalDescription: "This is to help with spiritual development", status: Constants.StatusStrings[1], categories: [], journalEntries: [
        JournalEntry(dateCreated: Date(), title: "Started 1 Nephi", body: "Loved the part about goodly parents."),
        JournalEntry(dateCreated: Date(), title: "Finished 1 Nephi", body: "His brothers really are the worst."),
        ])
                    , categories:
                    ["Spiritual"]),
    ]

struct SampleGoal {
    var goal: Goal
    var categories: [String]
}
