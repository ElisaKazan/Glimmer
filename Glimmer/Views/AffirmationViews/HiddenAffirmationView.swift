//
//  AffirmationAnimationView.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-18.
//

import SwiftUI

struct HiddenAffirmationView: View {
    @State var isPulsing: Bool = false
    @State var isFading: Bool = false

    var body: some View {
        VStack(spacing: 50) {
            animationSection

            Text("HOLD TO REVEAL")
                .font(.caption)
                .foregroundStyle(.glmrGrey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.glmrBackground)
    }

    @ViewBuilder private var animationSection: some View {
        ZStack {
            // Outer Ring (fades)
            Circle()
                .stroke(.glmrSecondary.opacity(0.10), lineWidth: 1)
                .frame(width: 200, height: 200)
                .scaleEffect(isFading ? 1.25 : 1.0)
                .opacity(isFading ? 0.0 : 1.0)

            // Inner Ring (solid)
            Circle()
                .stroke(.glmrSecondary.opacity(0.10), lineWidth: 1)
                .frame(width: 180, height: 180)

            // Outline Ring (pulses)
            Circle()
                .stroke(.glmrSecondary.opacity(0.15), lineWidth: 1)
                .frame(width: 160, height: 160)
                .scaleEffect(isPulsing ? 1.06 : 1.0)
                .opacity(isPulsing ? 1.0 : 0.5)

            // Filled Glow (pulses)
            Circle()
                .fill(
                    RadialGradient(
                        stops: [
                            .init(color: .glmrSecondary.opacity(0.20), location: 0.0),
                            .init(color: .glmrSecondary.opacity(0.15), location: 0.3),
                            .init(color: .glmrSecondary.opacity(0.10), location: 0.7),
                            .init(color: .glmrSecondary.opacity(0.05), location: 1.0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .scaleEffect(isPulsing ? 1.06 : 1.0)
                .opacity(isPulsing ? 0.80 : 1.0)

            // Centre Point (pulses)
            Circle()
                .stroke(.glmrSecondary.opacity(0.45), lineWidth: 2)
                .frame(width: 14, height: 14)
                .scaleEffect(isPulsing ? 1.04 : 1.0)
                .opacity(isPulsing ? 1.0 : 0.75)
        }
        .contentShape(Circle())
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
}

#Preview {
    HiddenAffirmationView()
}
