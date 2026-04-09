//
//  PeerSessionCoordinatorTests.swift
//  P2PMessenger
//
//  Created by Екатерина on 08.04.2026.
//

import Foundation
import Testing
@testable import P2PMessenger

struct PeerSessionCoordinatorTests {
    @Test
    @MainActor
    func lifecycleMethods_toggleRunningAndClearTransientState() {
        let (service, coordinator) = makeServiceAndCoordinator()
        let peer = makePeer(id: "peer", name: "Peer")

        coordinator.startIfNeeded()
        #expect(coordinator.isRunning)

        coordinator.networkService(service, peersChanged: [peer])
        coordinator.networkService(service, connectedPeersChanged: [peer])
        coordinator.networkService(service, connectingPeersChanged: [peer])
        coordinator.appMovedToBackground()

        #expect(!coordinator.isRunning)
        #expect(coordinator.discoveredPeers.isEmpty)
        #expect(coordinator.connectedPeers.isEmpty)
        #expect(coordinator.connectingPeers.isEmpty)
    }

    @Test
    @MainActor
    func subscriptions_receiveMessagesAndPeerStateNotifications() {
        let (service, coordinator) = makeServiceAndCoordinator()
        let peer = makePeer(id: "peer", name: "Peer")
        let message = makeMessage(
            senderID: peer.id,
            senderDisplayName: peer.displayName,
            timestamp: .distantPast,
            isIncoming: true
        )

        var delivered: [CoreChatMessage] = []
        var peerStateNotificationCount = 0

        coordinator.subscribe(onMessage: { delivered.append($0) })
        coordinator.subscribePeerStateChanges { peerStateNotificationCount += 1 }

        coordinator.networkService(service, didReceive: message)
        coordinator.networkService(service, peersChanged: [peer])
        coordinator.networkService(service, connectedPeersChanged: [peer])
        coordinator.networkService(service, connectingPeersChanged: [peer])

        #expect(delivered == [message])
        #expect(peerStateNotificationCount == 3)
        #expect(coordinator.isPeerConnected(peer))
        #expect(coordinator.isPeerConnecting(peer))
    }

    @Test
    @MainActor
    func delegateCallbacks_updateLocalPeerAndErrorState() {
        let (service, coordinator) = makeServiceAndCoordinator()
        let updated = makePeer(id: service.localPeer.id, name: "Renamed")

        coordinator.networkService(service, didUpdateLocalPeer: updated)
        coordinator.networkService(service, didEncounter: .peerUnavailable)

        #expect(coordinator.localPeer == updated)
        #expect(coordinator.latestError == .peerUnavailable)

        coordinator.clearError()
        #expect(coordinator.latestError == nil)
    }
}
