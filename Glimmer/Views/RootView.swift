//
//  RootView.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-10-07.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @State private var homeViewModel: HomeViewModel
    @State private var journalViewModel: JournalViewModel


    private let affirmationService: AffirmationServiceProtocol
    private let historyService: AffirmationHistoryServiceProtocol

    init(modelContext: ModelContext) {
        self.affirmationService = AffirmationService()
        self.historyService = AffirmationHistoryService(
            modelContext: modelContext
        )

        _homeViewModel = State(
            initialValue: HomeViewModel(
                affirmationService: affirmationService,
                historyService: historyService
            )
        )

        _journalViewModel = State(
            initialValue: JournalViewModel(
                historyService: historyService
            )
        )
    }

    var body: some View {
        // TODO: This is where we will implement the tabbed views
        HomeView(viewModel: homeViewModel)
    }
}
