//
//  Untitled.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation

struct InvitationContext: Codable {
    let protocolVersion: Int
    let senderID: String
    let senderDisplayName: String
    let senderLeaderID: String
    let senderClusterSize: Int
    let senderGroupEpoch: Int
}
