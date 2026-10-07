//
//  AffirmationService.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-24.
//

import Foundation

protocol AffirmationServiceProtocol {
    func getAffirmation() throws -> Affirmation
}

final class AffirmationService: AffirmationServiceProtocol {
    private var affirmationCache: [Affirmation]?

    let filename = "affirmation-database"

    struct Response: Codable {
        let affirmations: [Affirmation]
    }

    // Loads affirmations from json
    private func loadAffirmations() throws -> [Affirmation] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw AffirmationServiceError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(Response.self, from: data)

        return response.affirmations
    }

    // Lazy loading affirmations to prevent multiple calls to loadAffirmations
    private func getAffirmations() throws -> [Affirmation] {
        if let affirmationCache {
            return affirmationCache
        }

        let loadedAffirmations = try loadAffirmations()

        affirmationCache = loadedAffirmations

        return loadedAffirmations
    }

    // MARK: - Public Methods

    func getAffirmation() throws -> Affirmation {
        let affirmations = try getAffirmations()

        guard let affirmation = affirmations.randomElement() else {
            throw AffirmationServiceError.noAffirmations
        }
        return affirmation
    }
}

enum AffirmationServiceError: Error {
    case fileNotFound
    case noAffirmations

    var errorMessage: String {
        switch self {
        case .fileNotFound:
            "Could not find affirmation database file."
        case .noAffirmations:
            "Could get an affirmation, no affirmations found."
        }
    }
}
