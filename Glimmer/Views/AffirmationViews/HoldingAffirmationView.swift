//
//  HoldingAffirmationView.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-22.
//

import SwiftUI

struct HoldingAffirmationView: View {
    @State var isGlowing: Bool = false
    @State var progress: CGFloat = 0


    var body: some View {
        VStack(spacing: 50) {
            animationSection

            Text("ALMOST THERE...")
                .font(.caption)
                .foregroundStyle(.glmrGrey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.glmrBackground)
    }

    @ViewBuilder private var animationSection: some View {
        ZStack {
            // Outer Ring (loads)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    .glmrAccent,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 200, height: 200)
                .opacity(1.0)

            // Inner Ring
            Circle()
                .stroke(.glmrAccent.opacity(0.15), lineWidth: 1)
                .frame(width: 180, height: 180)

            // Outline Ring
            Circle()
                .stroke(.glmrAccent.opacity(0.40), lineWidth: 1)
                .frame(width: 160, height: 160)
                .opacity(1.0)

            // Filled Glow
            Circle()
                .fill(
                    RadialGradient(
                        stops: [
                            .init(color: .glmrAccent.opacity(0.50), location: 0.0),
                            .init(color: .glmrAccent.opacity(0.40), location: 0.3),
                            .init(color: .glmrAccent.opacity(0.25), location: 0.7),
                            .init(color: .glmrAccent.opacity(0.10), location: 1.0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 90
                    )
                )
                .frame(width: 200, height: 200)
                .opacity(1.0)

            // Centre Point
            Circle()
                .stroke(.glmrAccent, lineWidth: 2)
                .frame(width: 14, height: 14)

            // Centre Point Outline
            Circle()
                .stroke(.glmrAccent, lineWidth: 2)
                .frame(width: 20, height: 20)
        }
        .contentShape(Circle())
        .onAppear {
            // Glowing Animation
            withAnimation(
                .easeIn(duration: 3)
                .repeatForever(autoreverses: false)
            ) {
                isGlowing = true
            }

            // Loading Animation
            withAnimation(.linear(duration: 3)) {
                progress = 1
            }
        }
    }
}

#Preview {
    HoldingAffirmationView()
}
