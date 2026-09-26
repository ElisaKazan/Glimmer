//
//  AffirmationService.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-24.
//

import Foundation

protocol AffirmationServiceProtocol {
    func getAffirmation() -> Affirmation?
}

struct AffirmationService: AffirmationServiceProtocol {
    private var affirmations: [Affirmation] = []

    let filename = "affirmation-database"

    init() throws {
        affirmations = try loadAffirmations()
    }

    struct Response: Codable {
        let affirmations: [Affirmation]
    }

    // Loads affirmations from json to memory
    private func loadAffirmations() throws -> [Affirmation] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw AffirmationServiceError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(Response.self, from: data)

        return response.affirmations
    }

    func getAffirmation() -> Affirmation? {
        return affirmations.randomElement()
    }
}

enum AffirmationServiceError: Error {
    case fileNotFound

    var errorMessage: String {
        switch self {
        case .fileNotFound:
            "Could not find file."
        }
    }
}
