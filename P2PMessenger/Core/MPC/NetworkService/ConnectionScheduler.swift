//
//  ConnectionScheduler.swift
//  Sirius
//
//  Created by Екатерина on 06.04.2026.
//

import Foundation

final class ConnectionScheduler {
    private(set) var retryAfterByPeerID: [String: Date] = [:]
    private var retryWorkItems: [String: DispatchWorkItem] = [:]
    private var inviteExpiryWorkItems: [String: DispatchWorkItem] = [:]
    private var reevaluateWorkItem: DispatchWorkItem?

    func retryDate(for peerStableID: String) -> Date? {
        retryAfterByPeerID[peerStableID]
    }

    func clearRetryDate(for peerStableID: String) {
        retryAfterByPeerID.removeValue(forKey: peerStableID)
    }

    func clearAllRetryDates() {
        retryAfterByPeerID.removeAll()
    }

    func scheduleRetry(
        for peerStableID: String,
        at date: Date? = nil,
        isRunning: Bool,
        isSuspended: Bool,
        defaultBackoff: TimeInterval,
        onFire: @escaping () -> Void
    ) {
        guard isRunning, !isSuspended else { return }

        let fireDate = date ?? Date().addingTimeInterval(defaultBackoff)
        retryAfterByPeerID[peerStableID] = fireDate

        cancelRetry(for: peerStableID)

        let workItem = DispatchWorkItem { [weak self] in
            self?.retryWorkItems.removeValue(forKey: peerStableID)
            onFire()
        }

        retryWorkItems[peerStableID] = workItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + max(0.1, fireDate.timeIntervalSinceNow),
            execute: workItem
        )
    }

    func cancelRetry(for peerStableID: String) {
        retryWorkItems.removeValue(forKey: peerStableID)?.cancel()
    }

    func cancelAllRetries() {
        for peerStableID in retryWorkItems.keys {
            cancelRetry(for: peerStableID)
        }
    }

    func scheduleInviteExpiry(
        for peerStableID: String,
        after delay: TimeInterval,
        onExpire: @escaping () -> Void
    ) {
        cancelInviteExpiry(for: peerStableID)

        let workItem = DispatchWorkItem { [weak self] in
            self?.inviteExpiryWorkItems.removeValue(forKey: peerStableID)
            onExpire()
        }

        inviteExpiryWorkItems[peerStableID] = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    func cancelInviteExpiry(for peerStableID: String) {
        inviteExpiryWorkItems.removeValue(forKey: peerStableID)?.cancel()
    }

    func cancelAllInviteExpiry() {
        for peerStableID in inviteExpiryWorkItems.keys {
            cancelInviteExpiry(for: peerStableID)
        }
    }

    func scheduleReevaluation(
        after delay: TimeInterval,
        isRunning: @escaping () -> Bool,
        isSuspended: @escaping () -> Bool,
        onFire: @escaping () -> Void
    ) {
        reevaluateWorkItem?.cancel()

        let workItem = DispatchWorkItem {
            guard isRunning(), !isSuspended() else { return }
            onFire()
        }

        reevaluateWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    func cancelReevaluation() {
        reevaluateWorkItem?.cancel()
        reevaluateWorkItem = nil
    }
}
