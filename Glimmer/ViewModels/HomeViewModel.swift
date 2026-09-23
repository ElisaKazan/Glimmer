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
    var testAffirmation = Affirmation(
        text: "This is a sample affirmation used for testing.",
        category: .selfLove
    )

    // TODO: AffirmationService

    init(revealState: RevealState) {
        self.revealState = revealState
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

    func revealAffirmation() {
        revealState = .revealed
    }
}

enum RevealState {
    case revealed
    case hidden
}
