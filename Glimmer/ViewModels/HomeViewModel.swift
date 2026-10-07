//
//  HomeViewModel.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-18.
//

import Foundation

@Observable
final class HomeViewModel {
    var revealState: RevealState = .hidden
    var userName: String = "Elisa"

    private let affirmationService: AffirmationServiceProtocol
    private let historyService: AffirmationHistoryServiceProtocol

    init(
        affirmationService: AffirmationServiceProtocol,
        historyService: AffirmationHistoryServiceProtocol
    ) {
        self.affirmationService = affirmationService
        self.historyService = historyService
    }

    // Todays Date (i.e. "TUESDAY, SEPTEMBER 1")
    var formattedTodaysDate: String {
        Date.now.formatted(
            .dateTime
                .weekday(.wide)
                .month(.wide)
                .day()
        )
        .uppercased()
    }

    var greeting: String {
        "Hello \(userName)!"
    }

    // MARK: Public

    func revealAffirmation() {
        do {
            let affirmation = try affirmationService.getAffirmation()

            try historyService.save(affirmation, for: .now)

            revealState = .revealed(affirmation)
        } catch {
            print("ERROR: Failed to reveal today's affirmation - \(error)")
        }
    }

    func loadTodaysAffirmation() {
        // TODO: check history > restore reveal state if necessary
    }
}

enum RevealState {
    case revealed(Affirmation)
    case hidden
}
