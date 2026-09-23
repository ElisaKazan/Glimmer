//
//  HiddenAffirmationViewModel.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-23.
//

import SwiftUI

@Observable
final class AffirmationViewModel {
    var state: State
    var progress: CGFloat = 0
    var isHolding: Bool = false

    private var holdTask: Task<Void, Never>?
    private let onReveal: () -> Void

    let holdDuration: Double = 2.0

    var testAffirmation = Affirmation(
        text: "This is a sample affirmation used for testing.",
        category: .selfLove
    )

    init(state: State, onReveal: @escaping () -> Void) {
        self.state = state
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
        guard state == .holding else { return }

        isHolding = false
        state = .hidden

        withAnimation(.easeOut(duration: 0.4)) {
            progress = 0
        }
    }

    func revealAffirmation() {
        print("⭐️ REVEAL")
        state = .completed
        isHolding = false
        progress = 1

        // TODO: Change affirmation state to revealed
        onReveal()
    }

}

enum State {
    case hidden
    case holding
    case completed

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
}
