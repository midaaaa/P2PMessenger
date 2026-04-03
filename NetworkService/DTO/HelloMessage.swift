//
//  HelloMessage.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation

struct HelloMessage: Codable {
    let senderID: String
    let senderDisplayName: String
    let leaderID: String
    let clusterSize: Int
    let groupEpoch: Int
}
