//
//  ContentView.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-01.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            Spacer()

            affirmationSection

            Spacer()

            footerSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 8)
        .background(Color.glmrBackground)
    }

    @ViewBuilder private var headerSection: some View {
        VStack(alignment: .leading) {
            Text(viewModel.formattedTodaysDate)
                .font(.caption)
                .tracking(2)
                .foregroundStyle(.glmrSecondary)

            Text(viewModel.greeting)
                .font(.caption)
                .foregroundStyle(.glmrTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    @ViewBuilder private var affirmationSection: some View {
        ZStack {
            // Outer Ring
            Circle()
                .stroke(.white.opacity(0.06), lineWidth: 1)
                .frame(width: 200, height: 200)
                .scaleEffect(1.08)

            // Inner Ring
            Circle()
                .stroke(.white.opacity(0.08), lineWidth: 1)
                .frame(width: 180, height: 180)
                .scaleEffect(1.04)

            // Filled Glow
            Circle()
                .fill(.white.opacity(0.03))
                .frame(width: 160, height: 160)

            if viewModel.isRevealed {
                Text(viewModel.testAffirmation.text)
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .transition(.opacity)
            } else {
                // Center Point
                Circle()
                    .stroke(.glmrSecondary.opacity(0.3), lineWidth: 2)
                    .frame(width: 14, height: 14)
            }
        }
        .contentShape(Circle())
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
            ) {
                viewModel.isPulsing = true
            }
        }
    }

    @ViewBuilder private var footerSection: some View {
        VStack(alignment: .center) {
            Text("Carry this with you today.")
                .font(.caption)
                .foregroundStyle(.glmrGrey)

            Text("A new affirmation waits for you tomorrow.")
                .font(.caption)
                .foregroundStyle(.glmrGrey)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Entry.self, inMemory: true)
}
