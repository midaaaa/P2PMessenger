//
//  MeshChatViewModel.swift
//  P2PMessenger
//

import Foundation

/// Отвечает за меш (широковещательный) чат:
/// чтение сообщений из MessageStore и отправку через MPCNetworkService.
@MainActor
@Observable
final class MeshChatViewModel {

    var inputText = ""

    var messages: [CoreChatMessage] { store.meshMessages }
    var localPeer: ChatPeer { coordinator.localPeer }
    var hasConnectedPeers: Bool { !coordinator.connectedPeers.isEmpty }

    private let networkService: MPCNetworkService
    private let coordinator: PeerSessionCoordinator
    private let store: MessageStore

    init(networkService: MPCNetworkService, coordinator: PeerSessionCoordinator, store: MessageStore) {
        self.networkService = networkService
        self.coordinator = coordinator
        self.store = store
    }

    func send() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        networkService.sendToMesh(text: text)
        inputText = ""
    }
}
