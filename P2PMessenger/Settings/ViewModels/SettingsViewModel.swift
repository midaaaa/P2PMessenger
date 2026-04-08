//
//  SettingsViewModel.swift
//  P2PMessenger
//
//  Created on 06.04.2026.
//

import Observation

@Observable
final class SettingsViewModel {
    private let identityProvider: LocalPeerIdentityReading
    private let storage: KeyValueStorageProtocol
    private let onboardingState: OnboardingStateProtocol

    var username: String {
        didSet {
            _ = identityProvider.updateDisplayName(username)
        }
    }

    var spaceTaken: Int
    var progress: Double
    var visibilityToggle: Bool
    var requestToggle: Bool
    var networkToggle: Bool

    init(identityProvider: LocalPeerIdentityReading,
         storage: KeyValueStorageProtocol,
         onboardingState: OnboardingStateProtocol,
         spaceTaken: Int = 1234,
         progress: Double = 0.67,
         visibilityToggle: Bool = false,
         requestToggle: Bool = false,
         networkToggle: Bool = false) {
        self.identityProvider = identityProvider
        self.storage = storage
        self.onboardingState = onboardingState
        self.username = identityProvider.displayName
        self.spaceTaken = spaceTaken
        self.progress = progress
        self.visibilityToggle = visibilityToggle
        self.requestToggle = requestToggle
        self.networkToggle = networkToggle
    }

    func syncDisplayName() {
        username = identityProvider.displayName
    }

    @MainActor func clearAllData() {
        storage.removeAll()
        onboardingState.isOnboardingPassed = false
    }
}
