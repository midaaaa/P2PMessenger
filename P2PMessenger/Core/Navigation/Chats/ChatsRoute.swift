//
//  ChatsRoute.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//

enum ChatsRoute: Hashable {
    case searchDialog
    case addDialog(peer: ChatPeer)
}
