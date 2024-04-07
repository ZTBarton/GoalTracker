//
//  GoalContentView.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import SwiftUI
import SwiftData

struct GoalContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.modelContext) private var modelContext
    var goal: Goal
    
    @State private var showingNewEntryForm = false
    @State private var showingEditEntryForm = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            HStack {
                Text(goal.title)
                    .font(.system(size: 50, weight: .bold))
                PillView(text: goal.status)
            }
            
            Text("Due Date: \(formatDate(from: goal.dueDate))")
            
            Text("Date Created: \(formatDate(from: goal.dateAdded))")
            
            HStack {
                Spacer()
                Text("Journal Entries")
                    .font(.system(size: 30, weight: .bold))
                    .bold()
                    .padding(.top, 30)
                    .underline()
                Spacer()
            }
            VStack (alignment: .leading, spacing: 0) {
                ForEach(goal.journalEntries.sorted(by: { $0.dateCreated < $1.dateCreated })) { journalEntry in
                    HStack {
                        VStack (alignment: .leading) {
                            HStack {
                                Spacer()
                                Text(journalEntry.title).bold().padding(10)
                                Spacer()
                            }
                            Text(journalEntry.body)
                                .padding(.leading)
                                .padding(.vertical)
                        }
                        Spacer()
                        Button(action: { withAnimation {
                            showingEditEntryForm.toggle()
                        } }, label: {
                            Image(systemName: "pencil")
                        }).sheet(isPresented: $showingEditEntryForm) {
                            EntryEditor(journalEntry: journalEntry, goal: goal)
                        }
                    }
                    Divider().padding(.bottom, 10)
                }
                Button(action: addEntry) {
                    Text("New Journal Entry")
                }.sheet(isPresented: $showingNewEntryForm) {
                    EntryEditor(journalEntry: nil, goal: goal)
                }.padding(10)
            }.if(horizontalSizeClass == .regular) { view in
                view.padding()
            }
            
            Button(action: markCompleted) {
                Text(goal.isComplete ? "Completed!" : "Mark Completed!")
            }
            .frame(minWidth: 0, maxWidth: .infinity)  // Make the button expand to the full width
            .padding()  // Add some padding inside the button
            .background(.blue)  // Set the background color to blue
            .foregroundColor(.white)  // Set the text color to white
            .cornerRadius(10)
            .padding()
            .disabled(goal.isComplete)
        }
    }
    
    private func addEntry() {
        withAnimation {
            showingNewEntryForm.toggle()
        }
    }
    
    private func markCompleted() {
        goal.status = Constants.StatusStrings[2]
        goal.isComplete = true
        try? modelContext.save()
    }
    
    func formatDate(from: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        return formatter.string(from: from)
    }
}
    
//This was from chatGPT:
extension View {
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
