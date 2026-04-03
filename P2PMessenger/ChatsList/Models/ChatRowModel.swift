//
//  ChatRowModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 02.04.2026.
//

import Foundation

enum ChatStatus {
    case active
    case request
}

struct ChatRowModel: Identifiable {
    let id: UUID
    var name: String
    var timeOfLastMessage: Date
    var lastMessage: String
    var unreadCount: Int
    var isOnline: Bool
    var status: ChatStatus
}
