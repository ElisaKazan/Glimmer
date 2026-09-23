//
//  ContentView.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-01.
//

import SwiftUI
import SwiftData

/*
 * Home View
 * Starting view that contains a welcome header, the interactive affirmation view and an informational footer.
 */
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State var viewModel: HomeViewModel = HomeViewModel(revealState: .hidden)

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            Spacer()

            AffirmationView(
                viewModel: AffirmationViewModel(
                    state: .hidden,
                    onReveal: viewModel.revealAffirmation
                )
            )

            Spacer()

            footerSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 8)
        .background(.glmrBackground)
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

    @ViewBuilder private var footerSection: some View {
        VStack(alignment: .center) {
            switch viewModel.revealState {
            case .revealed:
                Text("Carry this with you today.")
                    .font(.footnote)
                    .foregroundStyle(.glmrGrey)

                Text("A new affirmation waits for you tomorrow.")
                    .font(.footnote)
                    .foregroundStyle(.glmrGrey)
            case .hidden:
                Text("One Affirmation. One Moment. Everyday.")
                    .font(.footnote)
                    .foregroundStyle(.glmrGrey)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Entry.self, inMemory: true)
}
