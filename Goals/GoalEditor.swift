//
//  GoalEditor.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import SwiftUI
import SwiftData
import Combine

struct GoalEditor: View {
    let goal: Goal?
    
    private var editorTitle: String {
        goal == nil ? "Add goal" : "Edit Goal"
    }
    
    @State var title: String = ""
    @State var goalDescription: String = ""
    @State var dueDate: Date = Date()
    @State var selectedStatus: String = Constants.StatusStrings[0]
    @State var selectedCategories: [GoalCategory] = []
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \GoalCategory.title) private var categories: [GoalCategory]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Title", text: $title)
                    
                    TextField("Description", text: $goalDescription, axis: .vertical)
                    
                    MultiSelector(
                        label: Text("Categories"),
                        options: categories,
                        optionToString: { $0.title },
                        selected: $selectedCategories
                    )
                    
                    Picker("Select an option", selection: $selectedStatus) {
                        ForEach(Constants.StatusStrings, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Due Date")
                    
                    DatePicker("Select Date and Time", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                // Display the selected date and time
//                Text("Selected Date and Time: \(dueDate.formatted())")
//                    .padding()
                }
                 
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
                    .disabled($title.wrappedValue.isEmpty || $selectedCategories.wrappedValue.count == 0)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let goal {
                    // Edit the incoming goal.
                    title = goal.title
                    goalDescription = goal.goalDescription ?? ""
                    dueDate = goal.dueDate
                    selectedStatus = goal.status
                    for cat in goal.categories {
                        selectedCategories.append(cat)
                    }
                }
            }
#if os(macOS)
            .padding()
#endif
        }
    }
    
    private func save() {
        if let goal {
            // Edit the goal.
            goal.title = title
            goal.goalDescription = goalDescription
            goal.dueDate = dueDate
            goal.status = selectedStatus
            goal.categories = selectedCategories
            
            if (selectedStatus == Constants.StatusStrings[2]) {
                goal.isComplete = true
            } else {
                goal.isComplete = false
            }

            try? modelContext.save()
            
        } else {
            // Add a goal.
            let newGoal = Goal(dateAdded: Date(), lastView: Date(), dueDate: dueDate, title: title, goalDescription: goalDescription, status: selectedStatus, categories: [], journalEntries: [])
            modelContext.insert(newGoal)
            if (selectedStatus == Constants.StatusStrings[2]) {
                newGoal.isComplete = true
            } else {
                newGoal.isComplete = false
            }
            
            for cat in selectedCategories {
                newGoal.categories.append(cat)
            }
            try? modelContext.save()
        }
    }
}

#Preview("Add goal") {
    GoalEditor(goal: nil)
        .modelContainer(for: Goal.self, inMemory: true)
}

