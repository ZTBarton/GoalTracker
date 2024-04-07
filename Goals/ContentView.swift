//
//  ContentView.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [GoalCategory]
    @Query(sort: [SortDescriptor(\Goal.dueDate)] )
    private var allGoals: [Goal]
    
    @State private var goalToEdit: Goal?
    
    @State private var unselectedCategories: Set<GoalCategory> = []
    @State private var completedFilterActive = false
    @State private var searchText = ""
    
    @State private var showingNewGoalForm = false
    @State private var showingEditGoalForm = false
    @State private var showingNewCategoryForm = false
    @State private var showingEditCategoryForm = false
    
    @State private var sidebarVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var preferredColumn = NavigationSplitViewColumn.detail
    
    

    var body: some View {
        NavigationSplitView (columnVisibility: $sidebarVisibility, preferredCompactColumn: $preferredColumn) {
            VStack {
                Text("Filter Goals")
                    .font(.title)
                    .bold()
                Divider()
                VStack {
                    HStack {
                        Text("Completed")
                        Spacer()
                        // Show a checkmark for selected items
                        if completedFilterActive {
                            Image(systemName: "checkmark")
                        }
                    }.contentShape(Rectangle()) // This ensures the tap is registered across the entire row
                        .onTapGesture {
                            // Toggle selection when the row is tapped
                            completedFilterActive.toggle()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                    Divider()
                        .padding(.leading)
                }.padding(.top, 20)
                
                Text("Categories")
                    .bold()
                    .padding(.top, 30)
                List(categories, selection: $unselectedCategories) { category in
                    HStack {
                        Text(category.title)
                        Spacer()
                        // Show a checkmark for selected items
                        if !unselectedCategories.contains(category) {
                            Image(systemName: "checkmark")
                        }
                    }.contentShape(Rectangle()) // This ensures the tap is registered across the entire row
                        .onTapGesture {
                            // Toggle selection when the row is tapped
                            if unselectedCategories.contains(category) {
                                unselectedCategories.remove(category)
                            } else {
                                unselectedCategories.insert(category)
                            }
                        }
//                        .sheet(isPresented: $showingEditCategoryForm) {
//                            CategoryEditor(category: category)
//                        }
                }
                .listStyle(PlainListStyle())
                Spacer()
                if UIDevice.current.userInterfaceIdiom == .phone {
                    // This view will only appear on iPhone
                    NavigationLink("View Goals") {
                        contentView
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)  // Make the button expand to the full width
                    .padding()  // Add some padding inside the button
                    .background(.selection)  // Set the background color to blue
                    .foregroundColor(.white)  // Set the text color to white
                    .cornerRadius(10)
                    .padding()
                        }
                HStack {
                    Button(action: showCategoryForm) {
                        Label("Add Category", systemImage: "folder.badge.plus")
                    }.sheet(isPresented: $showingNewCategoryForm) {
                        CategoryEditor(category: nil)
                    }.padding(.leading, 20)
                    Spacer()
                }
            }
        } content: {
            contentView
        } detail: {
//            Button("Load Sample Data") {
//                initializeData()
//            }
            Text("Select a Goal").bold()
        }.onAppear {
            initializeData()
        }
    }
    
    private var contentView: some View {
        VStack {
            TextField("Search", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(10)
            List {
                ForEach(filteredGoals()) {goal in
                    NavigationLink {
                        ScrollView {
                            VStack {
                                HStack (spacing: 15) {
                                    Spacer()
                                    Button(action: { withAnimation {
                                        showingEditGoalForm.toggle()
                                    } }, label: {
                                        Image(systemName: "pencil")
                                    })
                                }
                                HStack {
                                    GoalContentView(goal: goal)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 50)
                            .sheet(isPresented: $showingEditGoalForm) {
                                GoalEditor(goal: goal)
                            }
                        }
                    } label: {
                        HStack {
                            Text(goal.title)
                            Spacer()
                            PillView(text: goal.status)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .sheet(isPresented: $showingNewGoalForm) {
            GoalEditor(goal: $goalToEdit.wrappedValue)
        }
        .toolbar {
            //                    ToolbarItem(placement: .navigationBarTrailing) {
            //                        EditButton()
            //                    }
            ToolbarItem {
                Button(action: showNewGoalForm) {
                    Label("Add Recipe", systemImage: "plus")
                }
            }
        }
    }


    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(allGoals[index])
            }
        }
    }
    
    private func showNewGoalForm() {
        withAnimation {
            showingNewGoalForm.toggle()
        }
    }
    
    private func showCategoryForm() {
        withAnimation {
            showingNewCategoryForm.toggle()
        }
    }
    
    private func filteredGoals() -> [Goal] {
        var filtered = completedFilterActive ? allGoals.filter { $0.isComplete } : allGoals
        let includedCategories = categories.filter { !unselectedCategories.contains($0) }
        filtered = filtered.filter {
            var includeGoal = false
            for cat in $0.categories {
                if (includedCategories.contains(cat)) {
                    includeGoal = true
                }
            }
            return includeGoal
        }
        if (searchText != "") {
            filtered = filtered.filter {
                let goal = $0
                return "\(goal.title)\(String(describing: goal.goalDescription))".uppercased().contains(searchText.uppercased())
            }
        }
        return filtered
    }
    
    private func initializeData() {
        for goal in allGoals {
            modelContext.delete(goal)
        }
        for category in sampleCategories {
            modelContext.insert(category)
        }
        for sampleGoal in sampleGoals {
            let goal = sampleGoal.goal
            modelContext.insert(goal)
            for catString in sampleGoal.categories {
                let catModel = sampleCategories.filter { $0.title == catString }
                if (catModel.count > 0) {
                    goal.categories.append(catModel[0])
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
