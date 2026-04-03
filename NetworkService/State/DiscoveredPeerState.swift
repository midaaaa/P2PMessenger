//
//  DiscoveredPeerState.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation
import MultipeerConnectivity

struct DiscoveredPeerState {
    var peer: ChatPeer
    var peerID: MCPeerID
    var leaderID: String
    var clusterSize: Int
    var groupEpoch: Int
    var lastSeenAt: Date
}
