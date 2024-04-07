//
//  CategoryEditor.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import SwiftUI
import SwiftData

struct CategoryEditor: View {
    let category: GoalCategory?
    
    private var editorTitle: String {
        category == nil ? "Add Category" : "Edit Category Name"
    }
    
    @State var title: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
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
                if let category {
                    // Edit the incoming recipe.
                    title = category.title
                }
            }
#if os(macOS)
            .padding()
#endif
        }
    }
    
    private func save() {
        if let category {
            // Edit the category.
            category.title = title
            try? modelContext.save()
        } else {
            // Add a category.
            let newCategory = GoalCategory(
                dateAdded: Date(),
                lastUsed: Date(),
                title: title
                )
            modelContext.insert(newCategory)
            try? modelContext.save()
        }
    }
}

#Preview {
    CategoryEditor(category: nil)
        .modelContainer(for: Goal.self, inMemory: true)
}

