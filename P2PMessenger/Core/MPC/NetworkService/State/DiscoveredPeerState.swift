//
//  DiscoveredPeerState.swift
//  Sirius
//
//  Created by Екатерина on 04.04.2026.
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
