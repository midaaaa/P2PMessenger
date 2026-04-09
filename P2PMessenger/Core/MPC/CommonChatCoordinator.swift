//
//  CommonChatCoordinator.swift
//  P2PMessenger
//
//  Created by Дмитрий Филимонов on 07.04.2026.
//

import SwiftUI

@MainActor
@Observable
final class CommonChatCoordinator {
    private let maxStoredMessages = 300
    private var countParticipant = 1
    private let networkService: MPCNetworkService
    private let peerCoordinator: PeerSessionCoordinatorProtocol
    private let chatHistoryStorage: ChatHistoryStorageProtocol
    private var seenMessageIDs = Set<UUID>()
    private var commonChatMessages: [CoreChatMessage] = []

    init(
        networkService: MPCNetworkService,
        peerCoordinator: PeerSessionCoordinatorProtocol,
        chatHistoryStorage: ChatHistoryStorageProtocol
    ) {
        self.networkService = networkService
        self.peerCoordinator = peerCoordinator
        self.chatHistoryStorage = chatHistoryStorage

        restorePersistedState()
        bind()
        refreshState()
    }

    private func bind() {
        peerCoordinator.subscribe { [weak self] message in
            guard let self else { return }
            guard message.recipientID == nil else { return }
            guard seenMessageIDs.insert(message.id).inserted else { return }
            commonChatMessages.append(message)
            commonChatMessages.sort { $0.timestamp < $1.timestamp }
            trimStoredMessagesIfNeeded()
            persistState()
            refreshState()
        }

        peerCoordinator.subscribePeerStateChanges { [weak self] in
            self?.refreshState()
        }
    }

    var headerStyle: ChatHeaderStyle {
        .group(title: String(localized: "generalChat"), subtitle: String(localized: "\(countParticipant) \(participantWord(for: countParticipant))"))
    }

    private func participantWord(for count: Int) -> String {
        let lastTwo = count % 100
        if (11...14).contains(lastTwo) {
            return String(localized: "users11-14")
        }

        switch count % 10 {
        case 1:
            return String(localized: "users1")
        case 2...4:
            return String(localized: "users2-4")
        default:
            return String(localized: "users11-14")
        }
    }

    var chatTimelineTitle: String {
        switch headerStyle {
        case let .group(title, _) : return String(localized: "today \(title)")
            //String(format: String(localized: "today"), title)
        case .direct:
            assertionFailure()
            return ""
        }
    }

    var chatMessages: [ChatMessage] {
        let connectedPeers = peerCoordinator.connectedPeers
        let localPeerID = networkService.localPeer.id

        return commonChatMessages.map { message in
            let sender: ChatMessageSender
            if message.senderID == localPeerID {
                sender = .outgoing
            } else {
                sender = .incoming(
                    ChatParticipant(
                        name: message.senderDisplayName,
                        isOnline: connectedPeers.contains(where: { $0.id == message.senderID })
                    )
                )
            }

            return ChatMessage(
                id: message.id,
                sender: sender,
                text: message.text,
                time: Self.commonChatTimeFormatter.string(from: message.timestamp)
            )
        }
    }

    private func refreshState() {
        let connectedPeers = peerCoordinator.connectedPeers

        countParticipant = connectedPeers.count + 1
    }

    private func persistState() {
        chatHistoryStorage.saveMeshMessages(commonChatMessages)
    }

    private func restorePersistedState() {
        commonChatMessages = chatHistoryStorage.loadMeshMessages()
        trimStoredMessagesIfNeeded()
        seenMessageIDs = Set(commonChatMessages.map(\.id))
    }

    private func trimStoredMessagesIfNeeded() {
        guard commonChatMessages.count > maxStoredMessages else { return }
        commonChatMessages = Array(commonChatMessages.suffix(maxStoredMessages))
        seenMessageIDs = Set(commonChatMessages.map(\.id))
    }
}

private extension CommonChatCoordinator {
    static let commonChatTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
}
