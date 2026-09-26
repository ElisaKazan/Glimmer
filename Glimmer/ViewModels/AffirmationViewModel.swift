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
        // Can only start holding from hidden state
        guard case .hidden = state else {
            return
        }

        print("💚 START HOLD")
        state = .holding
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
        // Can only stop holding from holding state
        guard case .holding = state else {
            return
        }
        print("❤️ STOP HOLD")

        holdTask?.cancel()
        holdTask = nil
        state = .hidden

        withAnimation(.easeOut(duration: 0.4)) {
            progress = 0
        }
    }

    private func revealAffirmation() {
        // Fetch today's affirmation
        do {
            let todaysAffirmation = try affirmationService.getAffirmation()

            print("⭐️ REVEAL")
            state = .completed(todaysAffirmation)
            progress = 1

            onReveal(todaysAffirmation)
        } catch {
            print("ERROR - Failed to fetch today's affirmation: \(error)")
        }
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
