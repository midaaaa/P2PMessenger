//
//  AppRouter.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var container: DependencyContainer

    var body: some View {
        TabView(selection: Binding(
            get: { container.router.selectedTab },
            set: { container.router.selectedTab = $0 }
        )) {
            ChatsRootView(router: container.router.chatsRouter)
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
        .environmentObject(DependencyContainer())
}
