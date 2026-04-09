//
//  MeshTopologyCoordinatorTests.swift
//  P2PMessenger
//
//  Created by Екатерина on 08.04.2026.
//


import Foundation
import Testing
@testable import P2PMessenger

struct MeshTopologyCoordinatorTests {
    private let coordinator = MeshTopologyCoordinator()

    @Test // проверяет расчеты меш сети, чтобы не было гонок, циклов и спама инвайтов
    func leaderAndClusterSize_areDerivedFromConnectedPeerSet() {
        let leader = coordinator.currentLeaderID(localUserID: "c", connectedPeerIDs: ["a", "b"])
        let size = coordinator.currentClusterSize(connectedPeerIDs: ["a", "b"])

        #expect(leader == "a")
        #expect(size == 3)
        #expect(!coordinator.isLeader(localUserID: "c", connectedPeerIDs: ["a", "b"]))
        #expect(coordinator.isLeader(localUserID: "a", connectedPeerIDs: ["c", "b"]))
    }

    @Test // проверяет, кто должен инвайтить из двух узлов, чтобы не было встречных инвайтов
    func shouldInvitePeer_allowsOnlyDeterministicSingleNodeBootstrap() {
        let registry = PeerRegistry()
        let peerState = makeDiscoveredPeerState(stableID: "remote", name: "Remote")
        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: peerState.peerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: peerState.peer.id,
            MPCNetworkConstants.discoveryDisplayNameKey: peerState.peer.displayName
        ])

        let lifecycle = MPCNetworkLifecycleState(isRunning: true, hasStartedOnce: true, isSuspended: false)

        #expect(coordinator.shouldInvitePeer(localUserID: "a", lifecycleState: lifecycle, peerRegistry: registry, peerState: peerState))
        #expect(!coordinator.shouldInvitePeer(localUserID: "z", lifecycleState: lifecycle, peerRegistry: registry, peerState: peerState))
    }

    @Test // проверяет, чтобы инвайт не кидался пиру, если тот уже в сессии
    func shouldInvitePeer_respectsConnectionAndInvitationGuards() {
        let registry = PeerRegistry()
        let peerState = makeDiscoveredPeerState(stableID: "remote", name: "Remote")
        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: peerState.peerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: peerState.peer.id,
            MPCNetworkConstants.discoveryDisplayNameKey: peerState.peer.displayName
        ])
        registry.markConnected("remote")

        let lifecycle = MPCNetworkLifecycleState(isRunning: true, hasStartedOnce: true, isSuspended: false)
        #expect(!coordinator.shouldInvitePeer(localUserID: "local", lifecycleState: lifecycle, peerRegistry: registry, peerState: peerState))

        registry.unmarkConnected("remote")
        registry.markInvited("remote")
        #expect(!coordinator.shouldInvitePeer(localUserID: "local", lifecycleState: lifecycle, peerRegistry: registry, peerState: peerState))
    }

    @Test // проверяет кластеры на их защиту и слияние (можно принимать в кластер либо отдельных пиров, либо кластеры с тем же лидером, всё)
    func canAcceptInvitation_handlesClusterMergeRules() {
        let registry = PeerRegistry()
        let connectedA = makeDiscoveredPeerState(stableID: "a", name: "Alice", leaderID: "a", clusterSize: 2)
        let connectedB = makeDiscoveredPeerState(stableID: "b", name: "Bob", leaderID: "a", clusterSize: 2)
        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: connectedA.peerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: "a",
            MPCNetworkConstants.discoveryDisplayNameKey: "Alice"
        ])
        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: connectedB.peerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: "b",
            MPCNetworkConstants.discoveryDisplayNameKey: "Bob"
        ])
        registry.markConnected("a")
        registry.markConnected("b")

        #expect(coordinator.canAcceptInvitation(localUserID: "local", peerRegistry: registry, remoteID: "remote", senderLeaderID: "remote", senderClusterSize: 1))
        #expect(!coordinator.canAcceptInvitation(localUserID: "local", peerRegistry: registry, remoteID: "remote", senderLeaderID: "remote", senderClusterSize: 3))
        #expect(coordinator.canAcceptInvitation(localUserID: "local", peerRegistry: registry, remoteID: "remote", senderLeaderID: "a", senderClusterSize: 3))
    }

    @Test // проверяет работу retry и invite, чтобы при неудачном подключении не было спама инвайтами, а был выждан retry-time
    func evaluateConnection_returnsRetryOrInviteDependingOnRetryWindow() {
        let registry = PeerRegistry()
        let peerState = makeDiscoveredPeerState(stableID: "remote", name: "Remote")
        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: peerState.peerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: peerState.peer.id,
            MPCNetworkConstants.discoveryDisplayNameKey: peerState.peer.displayName
        ])

        let lifecycle = MPCNetworkLifecycleState(isRunning: true, hasStartedOnce: true, isSuspended: false)
        let retryDate = Date().addingTimeInterval(10)

        switch coordinator.evaluateConnection(
            for: "remote",
            localUserID: "a",
            lifecycleState: lifecycle,
            peerRegistry: registry,
            retryAfterByPeerID: ["remote": retryDate],
            now: Date()
        ) {
        case .retry(let date):
            #expect(date == retryDate)
        default:
            Issue.record("Expected retry decision")
        }

        switch coordinator.evaluateConnection(
            for: "remote",
            localUserID: "a",
            lifecycleState: lifecycle,
            peerRegistry: registry,
            retryAfterByPeerID: [:],
            now: Date()
        ) {
        case .invite(let peerID):
            #expect(peerID == peerState.peerID)
        default:
            Issue.record("Expected invite decision")
        }
    }

    @Test // проверяет корректность работы reevaluation (повторные расчеты меш сети), чтобы она в фоне не спамила расчетами
    func shouldScheduleReevaluation_onlyForActiveLeader() {
        let registry = PeerRegistry()
        registry.markConnected("a")

        #expect(!coordinator.shouldScheduleReevaluation(
            localUserID: "local",
            lifecycleState: MPCNetworkLifecycleState(isRunning: true, hasStartedOnce: true, isSuspended: true),
            peerRegistry: registry
        ))

        #expect(coordinator.shouldScheduleReevaluation(
            localUserID: "a",
            lifecycleState: MPCNetworkLifecycleState(isRunning: true, hasStartedOnce: true, isSuspended: false),
            peerRegistry: registry
        ))
    }
}
