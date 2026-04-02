@Observable
final class AppRouter {
    var selectedTab: AppTab = .chats

    let chatsRouter = ChatsRouter()
    let commonChatRouter = CommonChatRouter()
    let settingsRouter = SettingsRouter()
}