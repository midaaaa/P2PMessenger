//
//  AppRouter.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//


import SwiftUI
import Observation

@Observable
final class AppRouter: AppRouterProtocol {
    var selectedTab: AppTab = .chats
    
    var activeChatId: String? = nil

    let chatsRouter = ChatsRouter()

}

