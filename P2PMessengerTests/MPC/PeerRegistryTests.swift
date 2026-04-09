//
//  PeerRegistryTests.swift
//  P2PMessenger
//
//  Created by Екатерина on 08.04.2026.
//


import Foundation
import MultipeerConnectivity
import Testing
@testable import P2PMessenger

struct PeerRegistryTests {
    @Test //проверяет обновление состояния найденного пира на корректность (это еще чтобы не увидеть самого есбя в списке и не спамить инвайтами)
    func updateDiscoveredPeer_ignoresLocalPeerAndStoresRemoteState() {
        let registry = PeerRegistry()
        let remoteID = makeMCPeerID("Remote")

        let ignored = registry.updateDiscoveredPeer(
            localUserID: "local",
            peerID: remoteID,
            info: [MPCNetworkConstants.discoveryUserIDKey: "local"]
        )
        #expect(ignored == nil)
        #expect(registry.allPeerIDs.isEmpty)

        let storedID = registry.updateDiscoveredPeer(
            localUserID: "local",
            peerID: remoteID,
            info: [
                MPCNetworkConstants.discoveryUserIDKey: "remote",
                MPCNetworkConstants.discoveryDisplayNameKey: "Bob",
                MPCNetworkConstants.discoveryLeaderIDKey: "leader",
                MPCNetworkConstants.discoveryClusterSizeKey: "3",
                MPCNetworkConstants.discoveryGroupEpochKey: "7"
            ]
        )

        #expect(storedID == "remote")
        let state = registry.peerState(for: "remote")
        #expect(state?.peer.displayName == "Bob")
        #expect(state?.leaderID == "leader")
        #expect(state?.clusterSize == 3)
        #expect(state?.groupEpoch == 7)
    }

    @Test //проверяет сортировку пиров и чтобы один и тот же чел не попал в несколько списков
    func sortedCollections_returnAlphabeticalPeers_andConnectingExcludesConnected() {
        let registry = PeerRegistry()
        let annaPeerID = makeMCPeerID("Anna device")
        let zoePeerID = makeMCPeerID("Zoe device")

        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: zoePeerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: "zoe",
            MPCNetworkConstants.discoveryDisplayNameKey: "Zoe"
        ])
        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: annaPeerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: "anna",
            MPCNetworkConstants.discoveryDisplayNameKey: "Anna"
        ])

        registry.markConnecting("zoe")
        registry.markConnecting("anna")
        registry.markConnected("zoe")

        #expect(registry.discoveredPeersSorted().map(\.displayName) == ["Anna", "Zoe"])
        #expect(registry.connectedPeersSorted().map(\.displayName) == ["Zoe"])
        #expect(registry.connectingPeersSorted().map(\.displayName) == ["Anna"])
    }

    @Test //проверяет синхронизацию registry с реальной сессией, чтобы фактичсекие состояния сессии и пиров своевременно синхронились с локальными
    func refreshConnectedPeers_syncsKnownPeersTracksUnresolvedAndRemovesStaleConnecting() {
        let registry = PeerRegistry()
        let knownPeerID = makeMCPeerID("Known")
        let unknownPeerID = makeMCPeerID("Unknown")

        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: knownPeerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: "known",
            MPCNetworkConstants.discoveryDisplayNameKey: "Known"
        ])
        registry.markConnecting("known")
        registry.markConnecting("stale")

        let result = registry.refreshConnectedPeers(using: [knownPeerID, unknownPeerID])

        #expect(result.connectedChanged)
        #expect(result.staleConnectingRemoved)
        #expect(registry.connectedPeerIDs == Set(["known"]))
        #expect(registry.unresolvedConnectedPeerIDs == Set([unknownPeerID]))
        #expect(registry.connectingPeerIDs == Set(["known"]))
    }

    @Test //проверяет полную очистку состояния пира, чтобы он не зависал на каком-то конкретном состоянии
    func cleanupPeerState_clearsAllTransientFlags_andOptionallyDiscoveryState() {
        let registry = PeerRegistry()
        let peerID = makeMCPeerID("Remote")
        _ = registry.updateDiscoveredPeer(localUserID: "local", peerID: peerID, info: [
            MPCNetworkConstants.discoveryUserIDKey: "remote",
            MPCNetworkConstants.discoveryDisplayNameKey: "Remote"
        ])

        registry.markInvited("remote")
        registry.markIncomingInvitation("remote")
        registry.markConnecting("remote")
        registry.markConnected("remote")
        registry.markUnresolvedConnected(peerID)

        registry.cleanupPeerState(for: "remote", removeDiscovery: true)

        #expect(registry.peerState(for: "remote") == nil)
        #expect(!registry.invitedPeerIDs.contains("remote"))
        #expect(!registry.incomingInvitationPeerIDs.contains("remote"))
        #expect(!registry.connectingPeerIDs.contains("remote"))
        #expect(!registry.connectedPeerIDs.contains("remote"))
        #expect(!registry.unresolvedConnectedPeerIDs.contains(peerID))
    }
}
