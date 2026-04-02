//
//  AppRouter.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//

struct AppRootView: View {
    @State private var appRouter = AppRouter()

    var body: some View {
        TabView(selection: $appRouter.selectedTab) {
            ChatsRootView(router: appRouter.chatsRouter)
                .tabItem {
                    Label("Чаты", systemImage: "message")
                }
                .tag(AppTab.chats)

            CommonChatRootView(router: appRouter.commonChatRouter)
                .tabItem {
                    Label("Общий чат", systemImage: "person.2")
                }
                .tag(AppTab.commonChat)

            SettingsRootView(router: appRouter.settingsRouter)
                .tabItem {
                    Label("Настройки", systemImage: "gearshape")
                }
                .tag(AppTab.settings)
        }
    }
}
