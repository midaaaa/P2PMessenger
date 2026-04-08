//
//  Fixtures.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 04.04.2026.
//
import SwiftUI

// MARK: - Stubs

enum ChatListPreviewFixtures {
    static let stubChats: [ChatRowViewModel] = [
        ChatRowViewModel(
            id: "peer-1",
            name: "Вася",
            timeOfLastMessage: Date().addingTimeInterval(-3600),
            lastMessage: "Окей, до встречи!",
            unreadCount: 2,
            isOnline: true,
            status: .active
        ),
        ChatRowViewModel(
            id: "peer-2",
            name: "Маша",
            timeOfLastMessage: Date().addingTimeInterval(-7200),
            lastMessage: "Пришли ссылку позже",
            unreadCount: 0,
            isOnline: false,
            status: .active
        ),
        ChatRowViewModel(
            id: "peer-3",
            name: "Коля",
            timeOfLastMessage: Date().addingTimeInterval(-10800),
            lastMessage: "Всё понял, спасибо!",
            unreadCount: 0,
            isOnline: true,
            status: .active
        ),
        ChatRowViewModel(
            id: "peer-4",
            name: "Аня",
            timeOfLastMessage: Date().addingTimeInterval(-1800),
            lastMessage: "Привет! Можем пообщаться?",
            unreadCount: 1,
            isOnline: true,
            status: .request
        ),
        ChatRowViewModel(
            id: "peer-5",
            name: "Дима",
            timeOfLastMessage: Date().addingTimeInterval(-5400),
            lastMessage: "Добавь меня в контакты",
            unreadCount: 1,
            isOnline: false,
            status: .request
        )
    ]
}
