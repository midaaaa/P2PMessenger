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
    private var countParticipant = 1
    private let networkService: MPCNetworkService
    private let peerCoordinator: PeerSessionCoordinator
    private var commonChatMessages: [CoreChatMessage] = []

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

    var headerStyle: ChatHeaderStyle {
        .group(title: "Общий чат", subtitle: "\(countParticipant) участников")
    }

    var chatTimelineTitle: String {
        switch headerStyle {
        case let .group(title, _) : return "Сегодня \(title)"
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
