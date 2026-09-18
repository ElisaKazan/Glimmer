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
    var affirmation: Affirmation

    public init(timestamp: Date, affirmation: Affirmation) {
        self.timestamp = timestamp
        self.affirmation = affirmation
    }
}

@Model
final class Affirmation {
    var text: String
    var category: Category

    public init(text: String, category: Category) {
        self.text = text
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

    var title: String {
        switch self {
        case .selfLove:
            "Self-Love"
        case .confidence:
            "Confidence"
        case .success:
            "Success"
        case .abundance:
            "Abundance"
        case .wellBeing:
            "Well Being"
        case .relationships:
            "Relationships"
        case .peace:
            "Peace"
        case .growth:
            "Growth"
        }
    }

    var subheader: String {
        switch self {
        case .selfLove:
            "Embrace who you are"
        case .confidence:
            "Something"
        case .success:
            "Something else"
        case .abundance:
            "Invite prosperity in"
        case .wellBeing:
            "Honour your body"
        case .relationships:
            "Deepen your bonds"
        case .peace:
            "Find stillness within"
        case .growth:
            "Become who you're meant to be"
        }
    }
}
