//
//  MockAffirmationHistoryService.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-10-07.
//

import Foundation

final class MockAffirmationHistoryService: AffirmationHistoryServiceProtocol {
    let calendar: Calendar
    var records: [AffirmationRecord]

    init(
        calendar: Calendar = .current,
        records: [AffirmationRecord] = []
    ) {
        self.calendar = calendar
        self.records = records
    }

    func save(_ affirmation: Affirmation, for date: Date) throws {
        guard try getRecord(for: date) == nil else {
            return
        }
        
        let record = AffirmationRecord(
            date: date,
            affirmationID: affirmation.id,
            localDateIdentifier: date.localDateIdentifier(calendar: calendar)
        )

        records.append(record)
    }
    
    func getHistory() throws -> [AffirmationRecord] {
        records.sorted { $0.date > $1.date }
    }
    
    func getRecord(for date: Date) throws -> AffirmationRecord? {
        let localDateIdentifier = date.localDateIdentifier(
            calendar: calendar
        )

        return records.first {
            $0.localDateIdentifier == localDateIdentifier
        }
    }
}
