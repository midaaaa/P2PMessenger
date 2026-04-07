import Foundation

@MainActor
@Observable
final class CommonChatViewModel {
    var draftMessage = ""

    private let coordinator: CommonChatCoordinator
    private let networkService: MPCNetworkService

    init(coordinator: CommonChatCoordinator, networkSevice: MPCNetworkService) {
        self.coordinator = coordinator
        self.networkService = networkSevice
    }

    var chatScreenViewModel: ChatScreenViewModel {
        ChatScreenViewModel(
            networkService: networkService,
            headerStyle: coordinator.headerStyle,
            timelineTitle: coordinator.chatTimelineTitle,
            messages: coordinator.chatMessages
        )
    }

    func sendMeshMessage(_ text: String) {
        networkService.sendToMesh(text: text)
        draftMessage = ""
    }
}
