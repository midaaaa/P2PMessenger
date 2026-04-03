//
//  ConnectionState.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation
import MultipeerConnectivity

struct ConnectionState {
    var discoveredPeerStatesByID: [String: DiscoveredPeerState] = [:]

    var connectedPeerIDs = Set<String>()
    var connectingPeerIDs = Set<String>()
    var invitedPeerIDs = Set<String>()
    var incomingInvitationPeerIDs = Set<String>()

    var retryAfterByPeerID: [String: Date] = [:]
    var retryWorkItems: [String: DispatchWorkItem] = [:]
    var inviteExpiryWorkItems: [String: DispatchWorkItem] = [:]

    var unresolvedConnectedPeerIDs = Set<MCPeerID>()

    mutating func clearTransientConnectionState() {
        connectedPeerIDs.removeAll()
        connectingPeerIDs.removeAll()
        unresolvedConnectedPeerIDs.removeAll()
    }

    mutating func clearInvitationAndRetryState() {
        invitedPeerIDs.removeAll()
        incomingInvitationPeerIDs.removeAll()
        retryAfterByPeerID.removeAll()
    }
}
