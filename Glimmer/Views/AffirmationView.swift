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
    @State var viewModel: AffirmationViewModel

    // Decorative Animation
    @State var isPulsing: Bool = false
    @State var isFading: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.state {
            case .hidden, .holding:
                hiddenAffirmationView
            case .completed:
                revealedAffirmationView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.glmrBackground)
    }

    // MARK: - Hidden and Holding States

    @ViewBuilder private var hiddenAffirmationView: some View {
        VStack(spacing: 50) {
            animationSection

            Text(viewModel.state.hintText)
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
            .trim(from: 0, to: viewModel.progress)
            .stroke(
                viewModel.state.colour,
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
            .frame(width: 180, height: 180)
            .contentShape(Circle())
    }

    @ViewBuilder private var innerRing: some View {
        // Inner Ring (solid)
        Circle()
            .stroke(viewModel.state.colour.opacity(0.15), lineWidth: 1)
            .frame(width: 180, height: 180)
    }

    @ViewBuilder private var outlineRing: some View {
        // Outline Ring (pulses)
        Circle()
            .stroke(viewModel.state.colour.opacity(0.20 * viewModel.state.multiplier), lineWidth: 1)
            .frame(width: 160, height: 160)
            .scaleEffect(isPulsing ? 1.06 : 1.0)
            .opacity(isPulsing ? 1.0 : 0.5)
    }

    @ViewBuilder private var filledCircle: some View {
        // Filled Circle (pulses)
        let colour = viewModel.state.colour
        let multiplier = viewModel.state.multiplier
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
        let colour = viewModel.state.colour
        Circle()
            .stroke(colour.opacity(0.50 * viewModel.state.multiplier), lineWidth: 2)
            .frame(width: 14, height: 14)
            .scaleEffect(isPulsing ? 1.04 : 1.0)
            .opacity(isPulsing ? 1.0 : 0.75)

        // Centre Point Outline
        if viewModel.state == .holding {
            Circle()
                .stroke(colour, lineWidth: 2)
                .frame(width: 20, height: 20)
        }
    }

    // MARK: - Revealed State

    @ViewBuilder private var revealedAffirmationView: some View {
        VStack(alignment: .center, spacing: 16) {
            glowSection

            // Affirmation
            Text("\"\(viewModel.testAffirmation.text)\"")
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundStyle(.glmrPrimary)
                .padding(.horizontal, 14)

            // Caption
            Text(viewModel.state.hintText)
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
                guard viewModel.state != .completed, !viewModel.isHolding else { return }
                viewModel.startHolding()
            }
            .onEnded { _ in
                viewModel.stopHolding()
            }
    }
}

#Preview {
    AffirmationView(
        viewModel:
            AffirmationViewModel(
                state: .hidden,
                onReveal: {
                    // No-op
                }
            )
    )
}
