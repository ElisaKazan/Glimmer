//
//  Item.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-01.
//

import Foundation
import SwiftData

@Model
final class Entry {
    var timestamp: Date
    var affirmationText: String
    var category: Category

    init(timestamp: Date, affirmationText: String, category: Category) {
        self.timestamp = timestamp
        self.affirmationText = affirmationText
        self.category = category
    }
}

enum Category: String, Codable {
    case selfLove
    case confidence
    case success
    case abundance
    case wellBeing
    case relationships
    case peace
    case growth
}
