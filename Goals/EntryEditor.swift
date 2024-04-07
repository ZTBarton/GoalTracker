//
//  EntryEditor.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import SwiftUI
import SwiftData

struct EntryEditor: View {
    let journalEntry: JournalEntry?
    let goal: Goal
    
    private var editorTitle: String {
        journalEntry == nil ? "Add Entry" : "Edit Entry"
    }
    
    @State var title: String = ""
    @State var entrybody: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                
                TextEditor(text: $entrybody)
                .padding()
                .frame(minHeight: 100)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                    // Require a category to save changes.
                    .disabled($title.wrappedValue.isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let journalEntry {
                    // Edit the incoming recipe.
                    title = journalEntry.title
                    entrybody = journalEntry.body
                }
            }
#if os(macOS)
            .padding()
#endif
        }
    }
    
    private func save() {
        if let journalEntry {
            // Edit the entry.
            journalEntry.title = title
            journalEntry.body = entrybody
            try? modelContext.save()
        } else {
            // Add an entry.
            let newEntry = JournalEntry(
                dateCreated: Date(),
                title: title,
                body: entrybody
                )
            goal.journalEntries.append(newEntry)
            try? modelContext.save()
        }
    }
}

#Preview {
    CategoryEditor(category: nil)
        .modelContainer(for: Goal.self, inMemory: true)
}


