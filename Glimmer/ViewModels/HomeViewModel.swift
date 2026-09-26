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

    func revealAffirmation(_ affirmation: Affirmation) {
        revealState = .revealed(affirmation)
    }
}

enum RevealState {
    case revealed(Affirmation)
    case hidden

    var affirmationState: AffirmationState {
        switch self {
        case .revealed(let affirmation):
            .completed(affirmation)
        case .hidden:
            .hidden
        }
    }
}
