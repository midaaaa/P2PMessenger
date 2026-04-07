//
//  SettingsViewModel.swift
//  P2PMessenger
//
//  Created on 06.04.2026.
//

import Observation

@Observable
final class SettingsViewModel {
    var username: String
    var spaceTaken: Int
    var progress: Double
    var visibilityToggle: Bool
    var requestToggle: Bool
    var networkToggle: Bool

    init(username: String = "иван",
         spaceTaken: Int = 1234,
         progress: Double = 0.67,
         visibilityToggle: Bool = false,
         requestToggle: Bool = false,
         networkToggle: Bool = false) {
        self.username = username
        self.spaceTaken = spaceTaken
        self.progress = progress
        self.visibilityToggle = visibilityToggle
        self.requestToggle = requestToggle
        self.networkToggle = networkToggle
    }
}
