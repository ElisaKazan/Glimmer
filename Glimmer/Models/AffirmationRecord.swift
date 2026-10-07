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
    var date: Date
    var affirmationID: UUID
    // The calendar day the affirmation was revealed (ex: "YYYY-MM-DD")
    var localDate: String

    public init(
        date: Date,
        affirmationID: UUID,
        localDate: String,
    ) {
        self.date = date
        self.affirmationID = affirmationID
        self.localDate = localDate
    }
}
