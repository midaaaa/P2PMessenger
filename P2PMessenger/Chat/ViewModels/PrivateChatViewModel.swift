//
//  PrivateChatViewModel.swift
//  P2PMessenger
//

import Foundation

/// Отвечает за личный чат с конкретным пиром:
/// чтение сообщений из MessageStore и отправку через MPCNetworkService.
@MainActor
@Observable
final class PrivateChatViewModel {

    let peer: ChatPeer
    var inputText = ""

    var messages: [CoreChatMessage] { store.messages(for: peer.id) }
    var isConnected: Bool { coordinator.isPeerConnected(peer) }
    var localPeer: ChatPeer { coordinator.localPeer }

    private let networkService: MPCNetworkService
    private let coordinator: PeerSessionCoordinator
    private let store: MessageStore

    init(peer: ChatPeer, networkService: MPCNetworkService, coordinator: PeerSessionCoordinator, store: MessageStore) {
        self.peer = peer
        self.networkService = networkService
        self.coordinator = coordinator
        self.store = store
    }

    func send() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        networkService.sendPrivate(text: text, to: peer)
        inputText = ""
    }
}
