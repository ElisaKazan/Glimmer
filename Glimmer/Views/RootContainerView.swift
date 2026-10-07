//
//  RootContainerView.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-10-07.
//

import SwiftUI
import SwiftData

struct RootContainerView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        RootView(modelContext: modelContext)
    }
}
