//
//  HomeViewModel.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-18.
//

import Foundation

@MainActor
@Observable
final class HomeViewModel {
    var revealState: RevealState = .hidden
    var userName: String = "Elisa"

    private(set) var displayedDate: Date = .now

    private var loadedDayIdentifier: String?
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
        displayedDate.formatted(
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

    func revealAffirmation(for date: Date = .now) {
        let todaysIdentifier = date.localDateIdentifier()

        do {
            // Check if today's affirmation already exists
            if let record = try historyService.getRecord(for: date) {
                print("ERROR: Call to revealAffirmation even though affirmation has already been revealed.")

                let existingAffirmation = try affirmationService.getAffirmation(id: record.affirmationID)

                revealState = .revealed(existingAffirmation)
                loadedDayIdentifier = todaysIdentifier
                displayedDate = date

                return
            }

            // Generate new affirmation
            let affirmation = try affirmationService.getAffirmation()

            // Save the affirmation
            try historyService.save(affirmation, for: date)

            revealState = .revealed(affirmation)
            loadedDayIdentifier = todaysIdentifier
            displayedDate = date
        } catch {
            print("ERROR: Failed to reveal today's affirmation - \(error)")
        }
    }

    func loadTodaysAffirmation(for date: Date = .now) {
        let todaysIdentifier = date.localDateIdentifier()

        do {
            guard let record = try historyService.getRecord(for: date) else {
                // Today's affirmation is still hidden
                revealState = .hidden
                loadedDayIdentifier = todaysIdentifier
                displayedDate = date
                return
            }

            // Today's affirmation has already been revealed
            let affirmation = try affirmationService.getAffirmation(
                id: record.affirmationID
            )

            revealState = .revealed(affirmation)
            loadedDayIdentifier = todaysIdentifier
            displayedDate = date
        } catch {
            print("ERROR: Failed to load today's affirmation - \(error)")
        }
    }

    func reloadTodaysAffirmation(for date: Date = .now) {
        let todaysIdentifier = date.localDateIdentifier()

        // Only reload if the local date has changed
        guard loadedDayIdentifier != todaysIdentifier else { return }

        loadTodaysAffirmation(for: date)
    }
}

enum RevealState {
    case revealed(Affirmation)
    case hidden
}
