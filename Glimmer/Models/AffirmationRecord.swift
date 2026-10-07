//
//  AffirmationRecord.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-01.
//

import Foundation
import SwiftData

@Model
final class AffirmationRecord {
    // The unique calendar day the affirmation was revealed (ex: "YYYY-MM-DD")
    @Attribute(.unique)
    var localDateIdentifier: String

    // Exact date and time affirmation was revealed
    var date: Date
    // Unique ID for the affirmation
    var affirmationID: UUID

    public init(
        date: Date,
        affirmationID: UUID,
        localDateIdentifier: String,
    ) {
        self.date = date
        self.affirmationID = affirmationID
        self.localDateIdentifier = localDateIdentifier
    }
}
