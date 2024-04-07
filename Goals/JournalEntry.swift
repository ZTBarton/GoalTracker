//
//  Entry.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import Foundation
import SwiftData

@Model
final class JournalEntry {
    var dateCreated: Date
    var title: String
    var body: String
    
    init(dateCreated: Date, title: String, body: String) {
        self.dateCreated = dateCreated
        self.title = title
        self.body = body
    }
}
