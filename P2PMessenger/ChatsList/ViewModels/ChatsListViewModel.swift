//
//  ChatsListViewModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 02.04.2026.
//

import Foundation

@Observable
final class ChatsListViewModel {
    private var chats: [ChatRowModel] = stubChats

    var messageChats: [ChatRowModel] {
        chats
            .filter { $0.status == .active }
            .sorted { $0.timeOfLastMessage > $1.timeOfLastMessage }
    }

    var requestChats: [ChatRowModel] {
        chats
            .filter { $0.status == .request }
            .sorted { $0.timeOfLastMessage > $1.timeOfLastMessage }
    }

    var unreadMessagesCount: Int {
        messageChats.filter { $0.unreadCount > 0 }.count
    }

    var requestsCount: Int {
        requestChats.count
    }
}

// MARK: - Stubs

private extension ChatsListViewModel {
    static let stubChats: [ChatRowModel] = [
        ChatRowModel(
            id: UUID(),
            name: "Вася",
            timeOfLastMessage: Date().addingTimeInterval(-3600),
            lastMessage: "Окей, до встречи!",
            unreadCount: 2,
            isOnline: true,
            status: .active
        ),
        ChatRowModel(
            id: UUID(),
            name: "Маша",
            timeOfLastMessage: Date().addingTimeInterval(-7200),
            lastMessage: "Пришли ссылку позже",
            unreadCount: 0,
            isOnline: false,
            status: .active
        ),
        ChatRowModel(
            id: UUID(),
            name: "Коля",
            timeOfLastMessage: Date().addingTimeInterval(-10800),
            lastMessage: "Всё понял, спасибо!",
            unreadCount: 0,
            isOnline: true,
            status: .active
        ),
        ChatRowModel(
            id: UUID(),
            name: "Аня",
            timeOfLastMessage: Date().addingTimeInterval(-1800),
            lastMessage: "Привет! Можем пообщаться?",
            unreadCount: 1,
            isOnline: true,
            status: .request
        ),
        ChatRowModel(
            id: UUID(),
            name: "Дима",
            timeOfLastMessage: Date().addingTimeInterval(-5400),
            lastMessage: "Добавь меня в контакты",
            unreadCount: 1,
            isOnline: false,
            status: .request
        )
    ]
}
