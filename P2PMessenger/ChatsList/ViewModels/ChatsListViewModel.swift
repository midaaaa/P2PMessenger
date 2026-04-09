//
//  ChatsListViewModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 02.04.2026.
//

import Foundation

@MainActor
@Observable
final class ChatsListViewModel {
    private struct PersistedUnread: Codable {
        let countsByPeerID: [String: Int]
    }

    private var chatsByPeerID: [String: ChatRowViewModel] = [:]
    private let coordinator: PeerSessionCoordinator
    private let storage: KeyValueStorageProtocol
    private let unreadStorageKey = "chats.list.unread.counts"
    private var unreadByPeerID: [String: Int] = [:]

    var messageChats: [ChatRowViewModel] {
        chatsByPeerID.values
            .filter { $0.status == .active }
            .sorted { $0.timeOfLastMessage > $1.timeOfLastMessage }
    }

    var unreadMessagesCount: Int {
        messageChats.filter { $0.unreadCount > 0 }.count
    }

    init(coordinator: PeerSessionCoordinator, storage: KeyValueStorageProtocol) {
        self.coordinator = coordinator
        self.storage = storage
        restoreUnreadCounts()
        restoreChatsFromHistory()
        coordinator.subscribe(onMessage: { [weak self] message in
            self?.handleIncoming(message)
        })
        coordinator.subscribePeerStateChanges { [weak self] in
            self?.syncPeersState()
        }
        syncPeersState()
    }

    func upsertChat(with peer: ChatPeer) {
        if var row = chatsByPeerID[peer.id] {
            row.name = peer.displayName
            row.isOnline = coordinator.isPeerConnected(peer)
            row.unreadCount = unreadByPeerID[peer.id] ?? row.unreadCount
            chatsByPeerID[peer.id] = row
            return
        }

        chatsByPeerID[peer.id] = ChatRowViewModel(
            id: peer.id,
            name: peer.displayName,
            timeOfLastMessage: Date(),
            lastMessage: String(localized: "Начните диалог"),
            unreadCount: unreadByPeerID[peer.id] ?? 0,
            isOnline: coordinator.isPeerConnected(peer),
            status: .active
        )
    }

    func markChatAsRead(peerID: String) {
        guard var row = chatsByPeerID[peerID], row.unreadCount > 0 else { return }
        row.unreadCount = 0
        chatsByPeerID[peerID] = row
        unreadByPeerID[peerID] = 0
        persistUnreadCounts()
    }

    private func handleIncoming(_ message: CoreChatMessage) {
        guard let peerID = message.conversationPeerID else { return }
        let peer = coordinator.peer(withID: peerID) ?? ChatPeer(id: peerID, displayName: message.senderDisplayName)
        var row = chatsByPeerID[peerID] ?? ChatRowViewModel(
            id: peerID,
            name: peer.displayName,
            timeOfLastMessage: message.timestamp,
            lastMessage: message.text,
            unreadCount: 0,
            isOnline: coordinator.isPeerConnected(peer),
            status: .active
        )

        row.name = peer.displayName
        row.timeOfLastMessage = message.timestamp
        row.lastMessage = message.text
        if message.isIncoming {
            row.unreadCount += 1
            unreadByPeerID[peerID] = row.unreadCount
        }
        row.isOnline = coordinator.isPeerConnected(peer)
        chatsByPeerID[peerID] = row
        if !message.isIncoming {
            unreadByPeerID[peerID] = row.unreadCount
        }
        persistUnreadCounts()
    }

    private func syncPeersState() {
        for peer in coordinator.discoveredPeers {
            guard var row = chatsByPeerID[peer.id] else { continue }
            row.name = peer.displayName
            row.isOnline = coordinator.isPeerConnected(peer)
            chatsByPeerID[peer.id] = row
        }

        for peer in coordinator.connectedPeers {
            guard var row = chatsByPeerID[peer.id] else { continue }
            row.name = peer.displayName
            row.isOnline = true
            chatsByPeerID[peer.id] = row
        }
    }

    private func restoreChatsFromHistory() {
        for snapshot in coordinator.privateConversationSnapshots() {
            let peer = coordinator.peer(withID: snapshot.peerID)
                ?? ChatPeer(id: snapshot.peerID, displayName: snapshot.peerDisplayName)

            chatsByPeerID[snapshot.peerID] = ChatRowViewModel(
                id: snapshot.peerID,
                name: peer.displayName,
                timeOfLastMessage: snapshot.lastMessageDate,
                lastMessage: snapshot.lastMessageText,
                unreadCount: unreadByPeerID[snapshot.peerID] ?? 0,
                isOnline: coordinator.isPeerConnected(peer),
                status: .active
            )
        }
    }

    private func persistUnreadCounts() {
        let payload = PersistedUnread(countsByPeerID: unreadByPeerID.filter { $0.value > 0 })
        guard let data = try? JSONEncoder().encode(payload) else { return }
        storage.set(data, forKey: unreadStorageKey)
    }

    private func restoreUnreadCounts() {
        guard let data = storage.data(forKey: unreadStorageKey),
              let payload = try? JSONDecoder().decode(PersistedUnread.self, from: data) else {
            return
        }
        unreadByPeerID = payload.countsByPeerID
    }
}

