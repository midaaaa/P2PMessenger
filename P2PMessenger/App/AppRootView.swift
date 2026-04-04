//
//  AppRouter.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//

import SwiftUI

struct AppRootView: View {
    @Environment(DependencyContainer.self) var container

    var body: some View {
            TabView(selection: Binding(
                get: { container.router.selectedTab },
                set: { container.router.selectedTab = $0 }
            )) {
                ChatsRootView(
                    viewModel: ChatsRootViewModel(
                        chatListViewModel: ChatsListViewModel(
                            chats: ChatListPreviewFixtures.stubChats
                        ),
                        chatScreenViewModel: ChatPreviewFixtures.newChat
                    ),
                    router: container.router.chatsRouter)
                    .tabItem {
                        Label("Чаты", systemImage: "message")
                    }
                    .tag(AppTab.chats)
                
                CommonChatRootView()
                    .tabItem {
                        Label("Общий чат", systemImage: "person.2")
                    }
                    .tag(AppTab.commonChat)
                
                SettingsRootView()
                    .tabItem {
                        Label("Настройки", systemImage: "gearshape")
                    }
                    .tag(AppTab.settings)
            }
            .tint(.p2PBlack)
    }
}

#Preview {
    AppRootView()
        .environment(DependencyContainer())
}
