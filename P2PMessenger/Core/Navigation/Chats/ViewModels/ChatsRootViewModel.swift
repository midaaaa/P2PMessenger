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
    let chatScreenViewModel: ChatScreenViewModel
    let nearbyUserViewModel: NearbyUserViewModel

    @ObservationIgnored
    private let coordinator: PeerSessionCoordinator
    @ObservationIgnored
    private var privateChatCache: [String: PrivateChatViewModel] = [:]

    init(chatListViewModel: ChatsListViewModel,
         chatScreenViewModel: ChatScreenViewModel,
         nearbyUserViewModel: NearbyUserViewModel,
         coordinator: PeerSessionCoordinator) {
        self.chatListViewModel = chatListViewModel
        self.chatScreenViewModel = chatScreenViewModel
        self.nearbyUserViewModel = nearbyUserViewModel
        self.coordinator = coordinator
    }

    @MainActor
    func privateChatViewModel(for peer: ChatPeer) -> PrivateChatViewModel {
        if let cached = privateChatCache[peer.id] { return cached }
        let vm = PrivateChatViewModel(coordinator: coordinator, peer: peer)
        privateChatCache[peer.id] = vm
        return vm
    }
}
