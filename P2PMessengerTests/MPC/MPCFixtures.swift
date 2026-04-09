//
//  MPCFixtures.swift
//  P2PMessenger
//
//  Created by Екатерина on 08.04.2026.
//

import Foundation
import MultipeerConnectivity
@testable import P2PMessenger

func makeDefaults(_ name: String = UUID().uuidString) -> UserDefaults {
    let suiteName = "tests.\(name)"
    guard let defaults = UserDefaults(suiteName: suiteName) else {
        fatalError("Failed to create UserDefaults with suiteName: \(suiteName)")
    }

    defaults.removePersistentDomain(forName: suiteName)
    return defaults
}

func makePeer(id: String, name: String) -> ChatPeer {
    ChatPeer(id: id, displayName: name)
}

func makeMCPeerID(_ name: String) -> MCPeerID {
    MCPeerID(displayName: name)
}

func makeDiscoveredPeerState(
    stableID: String,
    name: String,
    peerName: String? = nil,
    leaderID: String? = nil,
    clusterSize: Int = 1,
    groupEpoch: Int = 1,
    lastSeenAt: Date = .distantPast
) -> DiscoveredPeerState {
    let peerID = MCPeerID(displayName: peerName ?? name)
    return DiscoveredPeerState(
        peer: ChatPeer(id: stableID, displayName: name),
        peerID: peerID,
        leaderID: leaderID ?? stableID,
        clusterSize: clusterSize,
        groupEpoch: groupEpoch,
        lastSeenAt: lastSeenAt
    )
}

func makeMessage(
    id: UUID = UUID(),
    text: String = "hello",
    senderID: String,
    senderDisplayName: String,
    recipientID: String? = nil,
    recipientDisplayName: String? = nil,
    timestamp: Date,
    isIncoming: Bool
) -> CoreChatMessage {
    CoreChatMessage(
        id: id,
        text: text,
        senderID: senderID,
        senderDisplayName: senderDisplayName,
        recipientID: recipientID,
        recipientDisplayName: recipientDisplayName,
        timestamp: timestamp,
        isIncoming: isIncoming
    )
}

@MainActor
func makeServiceAndCoordinator(
    defaults: UserDefaults = makeDefaults()
) -> (MPCNetworkServiceImpl, PeerSessionCoordinator) {
    let service = MPCNetworkServiceImpl(defaults: defaults)
    let coordinator = PeerSessionCoordinator(networkService: service)
    return (service, coordinator)
}
