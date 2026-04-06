//
//  WireMessage.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation

struct WireMessage: Codable {
    let id: UUID
    let text: String
    let senderID: String
    let senderDisplayName: String
    let recipientID: String?
    let recipientDisplayName: String?
    let timestamp: Date
}
