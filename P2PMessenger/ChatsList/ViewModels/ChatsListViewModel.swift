//
//  ChatsListViewModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 02.04.2026.
//

import Foundation

@Observable
final class ChatsListViewModel {
    private var chats: [ChatRowViewModel]

    var messageChats: [ChatRowViewModel] {
        chats
            .filter { $0.status == .active }
            .sorted { $0.timeOfLastMessage > $1.timeOfLastMessage }
    }

    var unreadMessagesCount: Int {
        messageChats.filter { $0.unreadCount > 0 }.count
    }
    
    init(chats: [ChatRowViewModel]) {
        self.chats = chats
    }
}

