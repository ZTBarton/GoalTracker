//
//  GoalsApp.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

// Built the icon with SF symbols and shapes in word!

import SwiftUI
import SwiftData

@main
struct GoalsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GoalCategory.self,
            Goal.self,
            JournalEntry.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
