//
//  PeerSessionCoordinator.swift
//  P2PMessenger
//

import Foundation

/// Единственный владелец делегата MPCNetworkServiceImpl.
/// Мультикастит события сети всем подписчикам через subscribe(onMessage:).
/// Все VM читают пир-состояние напрямую через @Observable.
@MainActor
@Observable
final class PeerSessionCoordinator: PeerSessionCoordinatorProtocol {
    struct PrivateConversationSnapshot {
        let peerID: String
        let peerDisplayName: String
        let lastMessageText: String
        let lastMessageDate: Date
    }

    // MARK: - Peer state (публичное @Observable состояние)

    private(set) var localPeer: ChatPeer
    private(set) var discoveredPeers: [ChatPeer] = []
    private(set) var connectedPeers: [ChatPeer] = []
    private(set) var connectingPeers: [ChatPeer] = []
    private(set) var isRunning = false
    private(set) var latestError: NetworkServiceError?

    // MARK: - Private

    private let networkService: MPCNetworkServiceImpl
    private let storage: KeyValueStorageProtocol
    private var messageHandlers: [(CoreChatMessage) -> Void] = []
    private var peerStateHandlers: [() -> Void] = []
    private var privateMessagesByPeerID: [String: [CoreChatMessage]] = [:]
    private var seenMessageIDs = Set<UUID>()
    private let privateMessagesStorageKey = "coordinator.private.messages"

    // MARK: - Init

    init(networkService: MPCNetworkServiceImpl, storage: KeyValueStorageProtocol) {
        self.networkService = networkService
        self.storage = storage
        self.localPeer = networkService.localPeer
        restorePersistedMessages()
        networkService.delegate = self
    }

    // MARK: - Lifecycle

    func startIfNeeded() {
        networkService.startIfNeeded()
        isRunning = true
    }

    func appBecameActive() {
        networkService.resumeIfNeeded()
        isRunning = true
    }

    func appMovedToBackground() {
        networkService.suspendForBackground()
        isRunning = false
        discoveredPeers = []
        connectedPeers = []
        connectingPeers = []
    }

    // MARK: - Peer queries

    func isPeerConnected(_ peer: ChatPeer) -> Bool {
        connectedPeers.contains { $0.id == peer.id }
    }

    func isPeerConnecting(_ peer: ChatPeer) -> Bool {
        connectingPeers.contains { $0.id == peer.id }
    }

    func peer(withID id: String) -> ChatPeer? {
        if localPeer.id == id { return localPeer }
        if let peer = connectedPeers.first(where: { $0.id == id }) { return peer }
        if let peer = discoveredPeers.first(where: { $0.id == id }) { return peer }
        return nil
    }

    // MARK: - Sending

    func sendPrivate(text: String, to peer: ChatPeer) {
        networkService.sendPrivate(text: text, to: peer)
    }

    // MARK: - Message subscription

    /// Регистрирует обработчик входящих сообщений.
    /// Вызывается любым числом подписчиков; все получат каждое сообщение.
    func subscribe(onMessage handler: @escaping (CoreChatMessage) -> Void) {
        messageHandlers.append(handler)
    }

    func privateMessages(for peerID: String) -> [CoreChatMessage] {
        privateMessagesByPeerID[peerID, default: []]
    }

    func privateConversationSnapshots() -> [PrivateConversationSnapshot] {
        privateMessagesByPeerID.compactMap { peerID, messages in
            guard let lastMessage = messages.last else { return nil }
            let peerName = lastMessage.isIncoming
                ? lastMessage.senderDisplayName
                : (lastMessage.recipientDisplayName ?? peerID)
            return PrivateConversationSnapshot(
                peerID: peerID,
                peerDisplayName: peerName,
                lastMessageText: lastMessage.text,
                lastMessageDate: lastMessage.timestamp
            )
        }
    }

    func subscribePeerStateChanges(_ handler: @escaping () -> Void) {
        peerStateHandlers.append(handler)
    }

    func clearError() {
        latestError = nil
    }

    private func notifyPeerStateChanged() {
        for handler in peerStateHandlers { handler() }
    }

    private func persistMessages() {
        guard let data = try? JSONEncoder().encode(privateMessagesByPeerID) else { return }
        storage.set(data, forKey: privateMessagesStorageKey)
    }

    private func restorePersistedMessages() {
        guard let data = storage.data(forKey: privateMessagesStorageKey),
              let restored = try? JSONDecoder().decode([String: [CoreChatMessage]].self, from: data) else {
            return
        }
        privateMessagesByPeerID = restored.mapValues { conversation in
            conversation.sorted { $0.timestamp < $1.timestamp }
        }
        seenMessageIDs = Set(privateMessagesByPeerID.values.flatMap { $0.map(\.id) })
    }
}

// MARK: - MPCNetworkServiceDelegate

extension PeerSessionCoordinator: MPCNetworkServiceDelegate {
    func networkService(_ service: MPCNetworkService, didReceive message: CoreChatMessage) {
        guard seenMessageIDs.insert(message.id).inserted else { return }
        if let peerID = message.conversationPeerID {
            var conversation = privateMessagesByPeerID[peerID, default: []]
            conversation.append(message)
            conversation.sort { $0.timestamp < $1.timestamp }
            privateMessagesByPeerID[peerID] = conversation
            persistMessages()
        }
        for handler in messageHandlers { handler(message) }
    }

    func networkService(_ service: MPCNetworkService, peersChanged peers: [ChatPeer]) {
        discoveredPeers = peers
        notifyPeerStateChanged()
    }

    func networkService(_ service: MPCNetworkService, connectedPeersChanged peers: [ChatPeer]) {
        connectedPeers = peers
        notifyPeerStateChanged()
    }

    func networkService(_ service: MPCNetworkService, connectingPeersChanged peers: [ChatPeer]) {
        connectingPeers = peers
        notifyPeerStateChanged()
    }

    func networkService(_ service: MPCNetworkService, didUpdateLocalPeer peer: ChatPeer) {
        localPeer = peer
    }

    func networkService(_ service: MPCNetworkService, didEncounter error: NetworkServiceError) {
        latestError = error
    }
}
