//
//  PrivateChatViewModel.swift
//  P2PMessenger
//

import Foundation

@MainActor
@Observable
final class PrivateChatViewModel: @MainActor ChatScreenViewModelProtocol {

    let peer: ChatPeer
    private let coordinator: PeerSessionCoordinator

    var inputText = ""
    private(set) var messages: [ChatMessage] = []

    // MARK: - ChatScreenViewModelProtocol

    var headerStyle: ChatHeaderStyle {
        let isOnline = coordinator.isPeerConnected(peer)
        let participant = ChatParticipant(
            name: peer.displayName,
            isOnline: isOnline
        )
        let subtitle = isOnline
            ? String(localized: "В сети")
            : String(localized: "Не в сети")
        return .direct(participant: participant, subtitle: subtitle)
    }

    let timelineTitle: String? = nil

    var emptyState: ChatEmptyState? {
        guard messages.isEmpty else { return nil }
        let participant = ChatParticipant(
            name: peer.displayName,
            isOnline: true
        )
        return ChatEmptyState(
            participant: participant,
            title: peer.displayName,
            subtitle: String(localized: "Напишите первое сообщение.\nСобеседник получит запрос на чат.")
        )
    }

    // MARK: - Init

    init(coordinator: PeerSessionCoordinator, peer: ChatPeer) {
        self.coordinator = coordinator
        self.peer = peer
        self.messages = coordinator.privateMessages(for: peer.id).map(Self.makeChatMessage(from:))

        coordinator.subscribe(onMessage: { [weak self] message in
            guard let self else { return }
            guard message.conversationPeerID == peer.id else { return }
            self.messages.append(Self.makeChatMessage(from: message))
        })
    }

    // MARK: - Actions

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        coordinator.sendPrivate(text: text, to: peer)
        inputText = ""
    }

    // MARK: - Private

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private static func formatTime(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }

    private static func makeChatMessage(from message: CoreChatMessage) -> ChatMessage {
        let sender: ChatMessageSender = message.isIncoming
            ? .incoming(ChatParticipant(name: message.senderDisplayName, isOnline: true))
            : .outgoing

        return ChatMessage(
            id: message.id,
            sender: sender,
            text: message.text,
            time: formatTime(message.timestamp)
        )
    }
}
