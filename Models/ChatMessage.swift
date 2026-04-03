//
//  ChatMessage.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation

struct ChatMessage: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let senderID: String
    let senderDisplayName: String
    let recipientID: String?
    let recipientDisplayName: String?
    let timestamp: Date
    let isIncoming: Bool

    var conversationPeerID: String? {
        if let recipientID {
            return isIncoming ? senderID : recipientID
        }
        return nil
    }
}
