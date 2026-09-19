//
//  RevealedAffirmationView.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-18.
//

import SwiftUI

struct RevealedAffirmationView: View {
    @State var affirmation: String = "I release what I cannot control, with grace."

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            glowSection

            // Affirmation
            Text("\"\(affirmation)\"")
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundStyle(.glmrPrimary)
                .padding(.horizontal, 14)

            // Caption
            Text("YOUR AFFIRMATION FOR TODAY")
                .font(.caption)
                .foregroundStyle(.glmrGrey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.glmrBackground)
    }

    @ViewBuilder private var glowSection: some View {
        ZStack {
            // Outer Ring
            Circle()
                .fill(.glmrAccent.opacity(0.15))
                .stroke(.glmrAccent.opacity(0.25), lineWidth: 1)
                .frame(width: 50, height: 50)

            // Middle Ring
            Circle()
                .stroke(.glmrAccent.opacity(0.70), lineWidth: 1)
                .frame(width: 14, height: 14)

            // Inner Ring
            Circle()
                .stroke(.glmrAccent.opacity(0.70), lineWidth: 1)
                .frame(width: 10, height: 10)
        }
        .contentShape(Circle())
    }
}

#Preview {
    RevealedAffirmationView()
}
