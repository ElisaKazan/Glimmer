//
//  MockAffirmationService.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-09-25.
//

import Foundation

struct MockAffirmationService: AffirmationServiceProtocol {
    let fakeAffirmation = Affirmation(
        id: UUID(uuidString: "01F47B4D-DAF9-44BF-8005-A170EB4EC2CC")!,
        text: "I embrace my uniqueness because that is my essence.",
        category: .selfLove
    )

    func getAffirmation() throws -> Affirmation {
        return fakeAffirmation
    }

}
