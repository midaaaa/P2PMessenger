//
//  Date+Formatting.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 02.04.2026.
//

import Foundation

extension Date {
    var shortTimeString: String {
        Self.shortTimeFormatter.string(from: self)
    }

    private static let shortTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
}
