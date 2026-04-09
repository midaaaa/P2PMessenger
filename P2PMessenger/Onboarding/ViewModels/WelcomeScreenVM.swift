//
//  WelcomeScreenVM.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 01.04.2026.
//

import Observation
import Foundation
import SwiftUI

@MainActor
@Observable
final class WelcomeScreenVM {

    let benefitsSectionContent: [BenefitItem] = [
        BenefitItem(title: String(localized: "findPeopleNearby"), icon: "1.circle"),
        BenefitItem(title: String(localized: "sendChatRequest"), icon: "2.circle"),
        BenefitItem(title: String(localized: "messageInPrivateAndGeneral"), icon: "3.circle")
    ]

    private let permissionManager: PermissionManager
    private let identityProvider: LocalPeerIdentityReading

    var userName: String = "" {
        didSet {
            _ = identityProvider.updateDisplayName(userName)
        }
    }

    private let onboardingState: OnboardingStateProtocol

    init(permissionManager: PermissionManager, 
         identityProvider: LocalPeerIdentityReading,
         onboardingState: OnboardingStateProtocol) {
        self.permissionManager = permissionManager
        self.identityProvider = identityProvider
        self.onboardingState = onboardingState
        self.userName = identityProvider.displayName
    }

    var permissions: [PermissionItem] {
        [
            PermissionItem(id: .bluetooth, title: "Bluetooth", icon: "dot.radiowaves.left.and.right", state: permissionManager.bluetoothState),
            PermissionItem(id: .localNetwork, title: String(localized: "localNetwork"), icon: "wifi", state: permissionManager.localNetworkState),
            PermissionItem(id: .notifications, title: String(localized: "notifications"), icon: "bell.badge", state: permissionManager.notificationsState)
        ]
    }

    var canGoForward: Bool {
        permissions.allSatisfy { $0.state == .granted } && !userName.isEmpty
    }

    func requestPermission(type: PermissionType) {
        switch type {
        case .bluetooth:        permissionManager.requestBluetooth()
        case .localNetwork:     permissionManager.requestLocalNetwork()
        case .nearbyDiscovery:  permissionManager.requestNearbyDiscovery()
        case .notifications:    permissionManager.requestNotifications()
        }
    }
    
    func syncDisplayName() {
        userName = identityProvider.displayName
    }

    func setOnboardingPassed() {
        onboardingState.markOnboardingPassed()
    }
    
}
