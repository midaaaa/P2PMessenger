//
//  PeerRegistry.swift
//  Sirius
//
//  Created by Екатерина on 06.04.2026.
//

import Foundation
import MultipeerConnectivity

struct PeerRefreshResult {
    let connectedChanged: Bool
    let staleConnectingRemoved: Bool
}

final class PeerRegistry {
    private(set) var discoveredPeerStatesByID: [String: DiscoveredPeerState] = [:]
    private(set) var connectedPeerIDs = Set<String>()
    private(set) var connectingPeerIDs = Set<String>()
    private(set) var invitedPeerIDs = Set<String>()
    private(set) var incomingInvitationPeerIDs = Set<String>()
    private(set) var unresolvedConnectedPeerIDs = Set<MCPeerID>()

    var allPeerIDs: [String] {
        Array(discoveredPeerStatesByID.keys)
    }

    func peerState(for peerStableID: String) -> DiscoveredPeerState? {
        discoveredPeerStatesByID[peerStableID]
    }

    func peer(for peerStableID: String) -> ChatPeer? {
        discoveredPeerStatesByID[peerStableID]?.peer
    }

    func discoveredPeersSorted() -> [ChatPeer] {
        discoveredPeerStatesByID.values
            .map(\.peer)
            .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
    }

    func connectedPeersSorted() -> [ChatPeer] {
        connectedPeerIDs
            .compactMap { discoveredPeerStatesByID[$0]?.peer }
            .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
    }

    func connectingPeersSorted() -> [ChatPeer] {
        connectingPeerIDs
            .subtracting(connectedPeerIDs)
            .compactMap { discoveredPeerStatesByID[$0]?.peer }
            .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
    }

    func knownStableID(for peerID: MCPeerID) -> String? {
        discoveredPeerStatesByID.first(where: { $0.value.peerID == peerID })?.key
    }

    @discardableResult
    func updateDiscoveredPeer(
        localUserID: String,
        peerID: MCPeerID,
        info: [String: String]?,
        constants: MPCNetworkConstants.Type = MPCNetworkConstants.self
    ) -> String? {
        guard let peerStableID = resolveStableID(
            for: peerID,
            discoveryInfo: info,
            constants: constants
        ), peerStableID != localUserID else {
            return nil
        }

        let displayName = info?[constants.discoveryDisplayNameKey] ?? peerID.displayName
        let leaderID = info?[constants.discoveryLeaderIDKey] ?? peerStableID
        let clusterSize = Int(info?[constants.discoveryClusterSizeKey] ?? "1") ?? 1
        let epoch = Int(info?[constants.discoveryGroupEpochKey] ?? "1") ?? 1
        let peer = ChatPeer(id: peerStableID, displayName: displayName)

        discoveredPeerStatesByID[peerStableID] = DiscoveredPeerState(
            peer: peer,
            peerID: peerID,
            leaderID: leaderID,
            clusterSize: max(1, clusterSize),
            groupEpoch: max(1, epoch),
            lastSeenAt: Date()
        )

        return peerStableID
    }

    func removeDiscoveredPeer(peerID: MCPeerID) -> String? {
        guard let peerStableID = knownStableID(for: peerID) else { return nil }
        cleanupPeerState(for: peerStableID, removeDiscovery: true)
        return peerStableID
    }

    func cleanupPeerState(for peerStableID: String, removeDiscovery: Bool = false) {
        invitedPeerIDs.remove(peerStableID)
        incomingInvitationPeerIDs.remove(peerStableID)
        connectedPeerIDs.remove(peerStableID)
        connectingPeerIDs.remove(peerStableID)

        if let knownPeerID = discoveredPeerStatesByID[peerStableID]?.peerID {
            unresolvedConnectedPeerIDs.remove(knownPeerID)
        }

        if removeDiscovery {
            discoveredPeerStatesByID.removeValue(forKey: peerStableID)
        }
    }

    func refreshConnectedPeers(using connectedPeerIDsFromSession: [MCPeerID]) -> PeerRefreshResult {
        let newConnectedIDs = Set(connectedPeerIDsFromSession.compactMap { knownStableID(for: $0) })
        unresolvedConnectedPeerIDs = Set(connectedPeerIDsFromSession.filter { knownStableID(for: $0) == nil })

        let connectedChanged = newConnectedIDs != connectedPeerIDs
        if connectedChanged {
            connectedPeerIDs = newConnectedIDs
        }

        let staleConnecting = connectingPeerIDs
            .subtracting(newConnectedIDs)
            .filter { discoveredPeerStatesByID[$0] == nil }

        let staleConnectingRemoved = !staleConnecting.isEmpty
        if staleConnectingRemoved {
            connectingPeerIDs.subtract(staleConnecting)
        }

        return PeerRefreshResult(
            connectedChanged: connectedChanged,
            staleConnectingRemoved: staleConnectingRemoved
        )
    }

    func clearTransientConnectionState() {
        connectedPeerIDs.removeAll()
        connectingPeerIDs.removeAll()
        unresolvedConnectedPeerIDs.removeAll()
    }

    func clearInvitationState() {
        invitedPeerIDs.removeAll()
        incomingInvitationPeerIDs.removeAll()
    }

    func markInvited(_ peerStableID: String) {
        invitedPeerIDs.insert(peerStableID)
    }

    func unmarkInvited(_ peerStableID: String) {
        invitedPeerIDs.remove(peerStableID)
    }

    func markIncomingInvitation(_ peerStableID: String) {
        incomingInvitationPeerIDs.insert(peerStableID)
    }

    func unmarkIncomingInvitation(_ peerStableID: String) {
        incomingInvitationPeerIDs.remove(peerStableID)
    }

    func markConnecting(_ peerStableID: String) {
        connectingPeerIDs.insert(peerStableID)
    }

    func unmarkConnecting(_ peerStableID: String) {
        connectingPeerIDs.remove(peerStableID)
    }

    func markConnected(_ peerStableID: String) {
        connectedPeerIDs.insert(peerStableID)
    }

    func unmarkConnected(_ peerStableID: String) {
        connectedPeerIDs.remove(peerStableID)
    }

    func markUnresolvedConnected(_ peerID: MCPeerID) {
        unresolvedConnectedPeerIDs.insert(peerID)
    }

    func unmarkUnresolvedConnected(_ peerID: MCPeerID) {
        unresolvedConnectedPeerIDs.remove(peerID)
    }

    private func resolveStableID(
        for peerID: MCPeerID,
        discoveryInfo: [String: String]?,
        constants: MPCNetworkConstants.Type
    ) -> String? {
        if let userID = discoveryInfo?[constants.discoveryUserIDKey] {
            return userID
        }
        return knownStableID(for: peerID)
    }
}
