//
//  AppRouter.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//


@Observable
final class AppRouter {
    var selectedTab: AppTab = .chats

    let chatsRouter = ChatsRouter()
    let commonChatRouter = CommonChatRouter()
    let settingsRouter = SettingsRouter()
}