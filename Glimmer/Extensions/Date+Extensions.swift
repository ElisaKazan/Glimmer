//
//  DateExtensions.swift
//  Glimmer
//
//  Created by Elisa Kazan on 2026-10-07.
//

import Foundation

extension Date {
    // Converts Date into "YYYY-MM-DD" string format given a calendar
    public func localDateIdentifier(calendar: Calendar = .autoupdatingCurrent) -> String {
        let components = calendar.dateComponents(
            [.year, .month, .day],
            from: self
        )

        return String(
            format: "%04d-%02d-%02d",
            components.year ?? 0,
            components.month ?? 0,
            components.day ?? 0
        )
    }
}
