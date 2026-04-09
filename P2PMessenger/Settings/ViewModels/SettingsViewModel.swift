//
//  SettingsViewModel.swift
//  P2PMessenger
//
//  Created on 06.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class SettingsViewModel {
    private let identityProvider: LocalPeerIdentityReading
    private let storage: KeyValueStorageProtocol
    private let onboardingState: OnboardingStateProtocol
    private let storageSizeProvider: StorageSizeProviding

    var username: String {
        didSet {
            _ = identityProvider.updateDisplayName(username)
        }
    }

    var formattedSpaceTaken: String = ""
    var visibilityToggle: Bool
    var requestToggle: Bool
    var networkToggle: Bool

    init(identityProvider: LocalPeerIdentityReading,
         storage: KeyValueStorageProtocol,
         onboardingState: OnboardingStateProtocol,
         storageSizeProvider: StorageSizeProviding = AppStorageSizeProvider(),
         visibilityToggle: Bool = false,
         requestToggle: Bool = false,
         networkToggle: Bool = false) {
        self.identityProvider = identityProvider
        self.storage = storage
        self.onboardingState = onboardingState
        self.storageSizeProvider = storageSizeProvider
        self.username = identityProvider.displayName
        self.visibilityToggle = visibilityToggle
        self.requestToggle = requestToggle
        self.networkToggle = networkToggle
    }

    func syncDisplayName() {
        username = identityProvider.displayName
    }

    func loadStorageSize() async {
        let bytes = await storageSizeProvider.calculateSize()
        formattedSpaceTaken = ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
    }

    func clearAllData() {
        storage.removeAll()
        onboardingState.isOnboardingPassed = false
    }
}
