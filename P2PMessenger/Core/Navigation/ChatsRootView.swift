//
//  ChatsRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//


struct ChatsRootView: View {
    @Bindable var router: ChatsRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            ChatListView()
                .navigationTitle("Список чатов")
                .navigationDestination(for: ChatsRoute.self) { route in
                    switch route {
                    case .dialog(let chatID):
                        ChatDialogView(chatID: chatID)

                    case .profile(let userID):
                        UserProfileView(userID: userID)

                    case .media(let chatID):
                        ChatMediaView(chatID: chatID)
                    }
                }
        }
    }
}