//
//  Status.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var titleAndAuthor: String
    var dateAdded: Date
    var lastView: Date
    var title: String
    var author: String
    var recipeDescription: String?
    @Relationship(inverse: \RecipeCategory.recipes) var categories: [RecipeCategory] = []
    var timeRequired: Int?
    var servings: Int?
    var difficultyLevel: Int?
    var calories: Int?
    var notes: [String]
    var tags: [String]
    var isFavorited: Bool = false
    
    @Relationship(deleteRule: .cascade) var ingredients: [Ingredient] = []
    
    @Relationship(deleteRule: .cascade) var instructions: [Step] = []
    
    
    init(dateAdded: Date, lastView: Date, title: String, author: String, recipeDescription: String?, categories: [RecipeCategory], ingredients: [Ingredient], instructions: [Step], timeRequired: Int?, servings: Int?, difficultyLevel: Int?, calories: Int?, notes: [String], tags: [String]) {
        self.dateAdded = dateAdded
        self.lastView = lastView
        self.title = title
        self.author = author
        self.recipeDescription = recipeDescription
        self.categories = categories
        self.ingredients = ingredients
        self.instructions = instructions
        self.timeRequired = timeRequired
        self.servings = servings
        self.difficultyLevel = difficultyLevel
        self.calories = calories
        self.notes = notes
        self.tags = tags
        self.titleAndAuthor = title + author
    }
}
