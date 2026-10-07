//
//  AffirmationHistoryService.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-30.
//

import Foundation
import SwiftData

protocol AffirmationHistoryServiceProtocol {
    func save(_ affirmation: Affirmation, for date: Date)
    func getHistory() -> [AffirmationRecord]
    func getRecord(for date: Date) -> AffirmationRecord?
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

    private func localDateIdentifier(for date: Date) -> String {
        let components = calendar.dateComponents(
            [.year, .month, .day],
            from: date
        )

        // Format: "YYYY-MM-DD"
        return String(
            format: "%04d-%02d-%02d",
            components.year ?? 0,
            components.month ?? 0,
            components.day ?? 0
        )
    }

    // MARK: Public

    func save(_ affirmation: Affirmation, for date: Date = .now) {
        // Check if affirmation has already been saved for this date
        guard getRecord(for: date) == nil else {
            print("ERROR - Cannot save affirmation, record already exists. ")
            return
        }

        let record = AffirmationRecord(
            date: date,
            affirmationID: affirmation.id,
            localDate: localDateIdentifier(for: date)
        )

        modelContext.insert(record)
    }
    
    func getHistory() -> [AffirmationRecord] {
        let descriptor = FetchDescriptor<AffirmationRecord>(
            sortBy: [
                SortDescriptor(\.date, order: .reverse)
            ]
        )

        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func getRecord(for date: Date) -> AffirmationRecord? {
        let localDate = localDateIdentifier(for: date)

        let descriptor = FetchDescriptor<AffirmationRecord>(
            predicate: #Predicate { record in
                record.localDate == localDate
            }
        )

        guard let records = try? modelContext.fetch(descriptor) else {
            return nil
        }

        // There should only ever be one affirmation per day
        if records.count > 1 {
            print("ERROR: Multiple affirmation records found for one day - \(date)")
        }

        return records.first
    }
}
