//
//  ChatsRootViewModel.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 04.04.2026.
//
import SwiftUI

@Observable
final class ChatsRootViewModel {
    let chatListViewModel: ChatsListViewModel
    let nearbyUserViewModel: NearbyUserViewModel

    @ObservationIgnored
    private let coordinator: PeerSessionCoordinatorProtocol
    @ObservationIgnored
    private var privateChatCache: [String: PrivateChatViewModel] = [:]

    init(chatListViewModel: ChatsListViewModel,
         nearbyUserViewModel: NearbyUserViewModel,
         coordinator: PeerSessionCoordinatorProtocol) {
        self.chatListViewModel = chatListViewModel
        self.nearbyUserViewModel = nearbyUserViewModel
        self.coordinator = coordinator
    }

    @MainActor
    func privateChatViewModel(for peer: ChatPeer) -> PrivateChatViewModel {
        chatListViewModel.upsertChat(with: peer)
        chatListViewModel.markChatAsRead(peerID: peer.id)
        if let cached = privateChatCache[peer.id] { return cached }
        let vm = PrivateChatViewModel(coordinator: coordinator, peer: peer)
        privateChatCache[peer.id] = vm
        return vm
    }

    @MainActor
    func peer(withID id: String) -> ChatPeer? {
        coordinator.peer(withID: id)
    }
}
