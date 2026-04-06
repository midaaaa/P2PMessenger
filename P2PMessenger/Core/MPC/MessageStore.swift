//
//  MessageStore.swift
//  P2PMessenger
//

import Foundation

/// Единственный источник правды для всех сообщений чата.
/// Подписывается на входящие сообщения через PeerSessionCoordinator
/// и сам обеспечивает персистентность через UserDefaults.
@MainActor
@Observable
final class MessageStore {

    private(set) var meshMessages: [CoreChatMessage] = []
    private(set) var privateMessages: [String: [CoreChatMessage]] = [:]

    private var seenMessageIDs = Set<UUID>()

    private let defaults: UserDefaults
    private let meshKey = "chat.mesh.messages"
    private let privateKey = "chat.private.messages"

    // MARK: - Init

    init(coordinator: PeerSessionCoordinator, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        restorePersistedState()
        coordinator.subscribe { [weak self] message in
            self?.append(message)
        }
    }

    // MARK: - Public

    func messages(for peerID: String) -> [CoreChatMessage] {
        privateMessages[peerID, default: []]
    }

    // MARK: - Internal (доступно MeshChatViewModel / PrivateChatViewModel для локальных копий)

    func append(_ message: CoreChatMessage) {
        guard seenMessageIDs.insert(message.id).inserted else { return }

        if let peerID = message.conversationPeerID {
            var msgs = privateMessages[peerID, default: []]
            insert(message, into: &msgs)
            privateMessages[peerID] = msgs
        } else {
            insert(message, into: &meshMessages)
        }

        persist()
    }

    // MARK: - Private

    private func insert(_ message: CoreChatMessage, into messages: inout [CoreChatMessage]) {
        if let last = messages.last, last.timestamp <= message.timestamp {
            messages.append(message)
            return
        }
        let idx = messages.firstIndex { $0.timestamp > message.timestamp } ?? messages.endIndex
        messages.insert(message, at: idx)
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if let data = try? encoder.encode(meshMessages) {
            defaults.set(data, forKey: meshKey)
        }
        if let data = try? encoder.encode(privateMessages) {
            defaults.set(data, forKey: privateKey)
        }
    }

    private func restorePersistedState() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        if let data = defaults.data(forKey: meshKey),
           let msgs = try? decoder.decode([CoreChatMessage].self, from: data) {
            meshMessages = msgs.sorted { $0.timestamp < $1.timestamp }
        }
        if let data = defaults.data(forKey: privateKey),
           let msgs = try? decoder.decode([String: [CoreChatMessage]].self, from: data) {
            privateMessages = msgs.mapValues { $0.sorted { $0.timestamp < $1.timestamp } }
        }

        seenMessageIDs = Set(meshMessages.map(\.id))
        for conv in privateMessages.values {
            seenMessageIDs.formUnion(conv.map(\.id))
        }
    }
}
