//
//  AffirmationView.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-23.
//

import SwiftUI

/*
 * Affirmation View
 * View that contains the animating circle or affirmation and hint text below.
 */
struct AffirmationView: View {
    let revealState: RevealState
    let onReveal: () -> Void
    let holdDuration: Double = 2.0

    // Interactive Hold Animation
    @State private var isHolding = false
    @State private var progress: CGFloat = 0
    @State private var holdTask: Task<Void, Never>?

    // Decorative Animation
    @State var isPulsing: Bool = false
    @State var isFading: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            switch revealState {
            case .revealed(let affirmation):
                revealedAffirmationView(affirmation)
            case .hidden:
                hiddenAffirmationView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.glmrBackground)
    }

    // MARK: - Hidden and Holding States

    @ViewBuilder private var hiddenAffirmationView: some View {
        VStack(spacing: 50) {
            animationSection

            Text(isHolding ? "KEEP HOLDING..." : "HOLD TO REVEAL")
                .font(.caption)
                .foregroundStyle(.glmrGrey)
        }
    }

    @ViewBuilder private var animationSection: some View {
        ZStack {
            outerRing
            progressRing
            innerRing
            outlineRing
            filledCircle
            mainCircle
        }
        .gesture(holdGesture)
        .onAppear {
            // Pulsing Animation
            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
            ) {
                isPulsing = true
            }

            // Fading Animation
            withAnimation(
                .easeOut(duration: 3)
                .repeatForever(autoreverses: false)
            ) {
                isFading = true
            }
        }
    }

    @ViewBuilder private var outerRing: some View {
        // Outer Ring (fading)
        Circle()
            .stroke(.glmrSecondary.opacity(0.10), lineWidth: 1)
            .frame(width: 200, height: 200)
            .scaleEffect(isFading ? 1.25 : 1.0)
            .opacity(isFading ? 0.0 : 1.0)
    }

    @ViewBuilder private var progressRing: some View {
        // Inner Ring (loading)
        Circle()
            .trim(from: 0, to: progress)
            .stroke(
                colour,
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
            .frame(width: 180, height: 180)
            .contentShape(Circle())
    }

    @ViewBuilder private var innerRing: some View {
        // Inner Ring (solid)
        Circle()
            .stroke(colour.opacity(0.15), lineWidth: 1)
            .frame(width: 180, height: 180)
    }

    @ViewBuilder private var outlineRing: some View {
        // Outline Ring (pulses)
        Circle()
            .stroke(colour.opacity(0.20 * multiplier), lineWidth: 1)
            .frame(width: 160, height: 160)
            .scaleEffect(isPulsing ? 1.06 : 1.0)
            .opacity(isPulsing ? 1.0 : 0.5)
    }

    @ViewBuilder private var filledCircle: some View {
        // Filled Circle (pulses)
        Circle()
            .fill(
                RadialGradient(
                    stops: [
                        .init(color: colour.opacity(0.25 * multiplier), location: 0.0),
                        .init(color: colour.opacity(0.20 * multiplier), location: 0.3),
                        .init(color: colour.opacity(0.125 * multiplier), location: 0.7),
                        .init(color: colour.opacity(0.05 * multiplier), location: 1.0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 80
                )
            )
            .frame(width: 160, height: 160)
            .scaleEffect(isPulsing ? 1.06 : 1.0)
            .opacity(isPulsing ? 0.80 : 1.0)
    }

    @ViewBuilder private var mainCircle: some View {
        Circle()
            .stroke(colour.opacity(0.50 * multiplier), lineWidth: 2)
            .frame(width: 14, height: 14)
            .scaleEffect(isPulsing ? 1.04 : 1.0)
            .opacity(isPulsing ? 1.0 : 0.75)

        // Centre Point Outline
        if isHolding {
            Circle()
                .stroke(colour, lineWidth: 2)
                .frame(width: 20, height: 20)
        }
    }

    // MARK: - Revealed State

    @ViewBuilder
    private func revealedAffirmationView(_ affirmation: Affirmation) -> some View {
        VStack(alignment: .center, spacing: 16) {
            glowSection

            // Affirmation
            Text("\(affirmation.prettyText)")
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundStyle(.glmrPrimary)
                .padding(.horizontal, 14)

            // Caption
            Text("YOUR AFFIRMATION FOR TODAY")
                .font(.caption)
                .foregroundStyle(.glmrGrey)
        }

    }

    @ViewBuilder private var glowSection: some View {
        ZStack {
            // Outer Ring
            Circle()
                .fill(.glmrAccent.opacity(0.15))
                .stroke(.glmrAccent.opacity(0.40), lineWidth: 1)
                .frame(width: 50, height: 50)

            // Middle Ring
            Circle()
                .stroke(.glmrAccent.opacity(0.80), lineWidth: 1)
                .frame(width: 14, height: 14)

            // Inner Ring
            Circle()
                .stroke(.glmrAccent.opacity(0.80), lineWidth: 1)
                .frame(width: 10, height: 10)
        }
        .contentShape(Circle())
    }

    // MARK: - Gesture

    private var holdGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                startHolding()
            }
            .onEnded { _ in
                stopHolding()
            }
    }

    private func startHolding() {
        // Can only start holding from hidden state
        guard case .hidden = revealState, !isHolding else { return }

        print("💚 START HOLDING")
        isHolding = true
        progress = 0

        withAnimation(.linear(duration: holdDuration)) {
            progress = 1
        }

        holdTask = Task {
            try? await Task.sleep(for: .seconds(holdDuration))

            guard !Task.isCancelled else { return }

            await MainActor.run {
                onReveal()
            }
        }
    }

    private func stopHolding() {
        // Can only stop holding from holding state
        guard isHolding else { return }

        print("❤️ STOP HOLDING")

        holdTask?.cancel()
        holdTask = nil
        isHolding = false

        withAnimation(.easeOut(duration: 0.4)) {
            progress = 0
        }
    }
}

// MARK: State Properties

extension AffirmationView {

    private var colour: Color {
        switch revealState {
        case .revealed:
            return .glmrAccent
        case .hidden:
            return isHolding ? .glmrAccent : .glmrSecondary
        }
    }

    private var multiplier: Double {
        switch revealState {
        case .revealed:
            return 0
        case .hidden:
            return isHolding ? 2 : 1
        }
    }

    private var isCompleted: Bool {
        if case .revealed = revealState {
            return true
        }

        return false
    }
}

#Preview {
    let affirmationService = MockAffirmationService()
    AffirmationView(revealState: .hidden) {
        // No-op
    }
}
