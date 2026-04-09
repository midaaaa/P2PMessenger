//
//  OnboardingStateProtocol.swift
//  P2PMessenger
//
//  Created by Antigravity on 08.04.2026.
//

import Foundation

@MainActor
protocol OnboardingStateProtocol: AnyObject {
    var isOnboardingPassed: Bool { get set }
    func markOnboardingPassed()
}
