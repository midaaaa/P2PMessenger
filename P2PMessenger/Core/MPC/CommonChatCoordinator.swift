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
    private(set) var participantsSubtitle = "1 участников"
    private let networkService: MPCNetworkService
    private let peerCoordinator: PeerSessionCoordinator
    private var commonChatMessages: [CoreChatMessage] = []
    private let timelineTitle = "Сегодня · Общий чат"

    init(networkService: MPCNetworkService, peerCoordinator: PeerSessionCoordinator) {
        self.networkService = networkService
        self.peerCoordinator = peerCoordinator

        bind()
        refreshState()
    }

    private func bind() {
        peerCoordinator.subscribe { [weak self] message in
            guard let self else { return }
            guard message.recipientID == nil else { return }
            commonChatMessages.append(message)
            commonChatMessages.sort { $0.timestamp < $1.timestamp }
            refreshState()
        }

        peerCoordinator.subscribePeerStateChanges { [weak self] in
            self?.refreshState()
        }
    }

    func sendMeshMessage(_ text: String) {
        networkService.sendToMesh(text: text)
    }

    var headerStyle: ChatHeaderStyle {
        .group(title: "Общий чат", subtitle: participantsSubtitle)
    }

    var chatTimelineTitle: String {
        timelineTitle
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

    var chatNetworkService: MPCNetworkService {
        networkService
    }

    private func refreshState() {
        let connectedPeers = peerCoordinator.connectedPeers

        participantsSubtitle = "\(connectedPeers.count + 1) участников"
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
