//
//  ChatPeer.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation

struct ChatPeer: Identifiable, Hashable, Codable {
    let id: String
    let displayName: String
}
