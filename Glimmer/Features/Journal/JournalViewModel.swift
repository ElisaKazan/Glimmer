//
//  JournalViewModel.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-10-07.
//

import Foundation

@Observable
final class JournalViewModel {
    private let historyService: AffirmationHistoryServiceProtocol

    init(
        historyService: AffirmationHistoryServiceProtocol
    ) {
        self.historyService = historyService
    }
}
