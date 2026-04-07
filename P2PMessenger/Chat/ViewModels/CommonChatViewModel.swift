import Foundation

@MainActor
@Observable
final class CommonChatViewModel {
    var draftMessage = ""

    private let coordinator: CommonChatCoordinator

    init(coordinator: CommonChatCoordinator) {
        self.coordinator = coordinator
    }

    var chatScreenViewModel: ChatScreenViewModel {
        ChatScreenViewModel(
            networkService: coordinator.chatNetworkService,
            headerStyle: coordinator.headerStyle,
            timelineTitle: coordinator.chatTimelineTitle,
            messages: coordinator.chatMessages
        )
    }

    func sendMeshMessage(_ text: String) {
        coordinator.sendMeshMessage(text)
        draftMessage = ""
    }
}
