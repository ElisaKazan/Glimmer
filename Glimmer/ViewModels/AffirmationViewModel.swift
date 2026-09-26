//
//  AffirmationViewModel.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-23.
//

import SwiftUI

@Observable
final class AffirmationViewModel {
    var state: AffirmationState
    var progress: CGFloat = 0
    var isHolding: Bool = false

    private var holdTask: Task<Void, Never>?
    private let onReveal: (Affirmation) -> Void

    private let holdDuration: Double = 2.0
    private let affirmationService: AffirmationServiceProtocol


    init(
        state: AffirmationState,
        affirmationService: AffirmationServiceProtocol,
        onReveal: @escaping (Affirmation) -> Void,
    ) {
        self.state = state
        self.affirmationService = affirmationService
        self.onReveal = onReveal
    }

    func startHolding() {
        print("💚 START HOLD")
        state = .holding
        isHolding = true
        progress = 0

        withAnimation(.linear(duration: holdDuration)) {
            progress = 1
        }

        holdTask = Task {
            try? await Task.sleep(for: .seconds(holdDuration))

            guard !Task.isCancelled else { return }

            await MainActor.run {
                revealAffirmation()
            }
        }
    }

    func stopHolding() {
        print("❤️ STOP HOLD")
        guard isHolding else { return }

        holdTask?.cancel()
        holdTask = nil

        // Only reset if they haven't successfully revealed
        guard case .holding = state else { return }

        isHolding = false
        state = .hidden

        withAnimation(.easeOut(duration: 0.4)) {
            progress = 0
        }
    }

    func revealAffirmation() {
        // Fetch today's affirmation
        guard let todaysAffirmation = affirmationService.getAffirmation() else {
            // Error - failed to fetch today's affirmation
            print("ERROR - Failed to fetch today's affirmation")
            return
        }

        print("⭐️ REVEAL")
        state = .completed(todaysAffirmation)
        isHolding = false
        progress = 1

        // TODO: Change affirmation state to revealed
        onReveal(todaysAffirmation)
    }

}

enum AffirmationState {
    case hidden
    case holding
    case completed(Affirmation)

    var hintText: String {
        switch self {
        case .hidden:
            "HOLD TO REVEAL"
        case .holding:
            "KEEP HOLDING..."
        case .completed:
            "YOUR AFFIRMATION FOR TODAY"
        }
    }

    var colour: Color {
        switch self {
        case .hidden:
            .glmrSecondary
        case .holding, .completed:
            .glmrAccent
        }
    }

    var multiplier: Double {
        switch self {
        case .hidden:
            1
        case .holding:
            2
        case .completed:
            0
        }
    }

    var isCompleted: Bool {
        switch self {
        case .hidden, .holding:
            false
        case .completed:
            true
        }
    }
}
