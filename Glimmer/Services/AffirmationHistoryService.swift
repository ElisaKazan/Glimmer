//
//  AffirmationHistoryService.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-30.
//

import Foundation
import SwiftData

protocol AffirmationHistoryServiceProtocol {
    func save(_ affirmation: Affirmation, for date: Date) throws
    func getHistory() throws -> [AffirmationRecord]
    func getRecord(for date: Date) throws -> AffirmationRecord?
}

final class AffirmationHistoryService: AffirmationHistoryServiceProtocol {

    private let modelContext: ModelContext
    private let calendar: Calendar

    init(
        modelContext: ModelContext,
        calendar: Calendar = .current
    ) {
        self.modelContext = modelContext
        self.calendar = calendar
    }

    // MARK: AffirmationHistoryServiceProtocol

    func save(_ affirmation: Affirmation, for date: Date = .now) throws {
        // Check if affirmation has already been saved for this date
        guard try getRecord(for: date) == nil else {
            print("ERROR - Cannot save affirmation, record already exists. ")
            return
        }

        let record = AffirmationRecord(
            date: date,
            affirmationID: affirmation.id,
            localDateIdentifier: date.localDateIdentifier(calendar: calendar)
        )

        modelContext.insert(record)
        try modelContext.save()
    }
    
    func getHistory() throws -> [AffirmationRecord] {
        let descriptor = FetchDescriptor<AffirmationRecord>(
            sortBy: [
                SortDescriptor(\.date, order: .reverse)
            ]
        )

        return try modelContext.fetch(descriptor)
    }
    
    func getRecord(for date: Date) throws -> AffirmationRecord? {
        let localDateIdentifier = date.localDateIdentifier(calendar: calendar)

        let descriptor = FetchDescriptor<AffirmationRecord>(
            predicate: #Predicate { record in
                record.localDateIdentifier == localDateIdentifier
            }
        )

        let records = try modelContext.fetch(descriptor)

        // There should only ever be one affirmation per day
        if records.count > 1 {
            print("ERROR: Multiple affirmation records found for one day - \(date)")
        }

        return records.first
    }
}
