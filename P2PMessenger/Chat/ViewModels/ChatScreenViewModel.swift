//
//  ChatScreenViewModel.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 04.04.2026.
//

import SwiftUI

@Observable
final class ChatScreenViewModel {
    let networkService: MPCNetworkService
    let headerStyle: ChatHeaderStyle
    let timelineTitle: String?
    let messages: [ChatMessage]
    let emptyState: ChatEmptyState?
    
    var privateInputText = ""
    var isPeersScreenPresented = false
    var selectedPeer: ChatPeer?
    var privateMessages: [String : [ChatMessage]] = [:]

    init(
        networkService: MPCNetworkService,
        headerStyle: ChatHeaderStyle,
        timelineTitle: String? = nil,
        messages: [ChatMessage] = [],
        emptyState: ChatEmptyState? = nil,
    ) {
        self.networkService = networkService
        self.headerStyle = headerStyle
        self.timelineTitle = timelineTitle
        self.messages = messages
        self.emptyState = emptyState
    }
    
    func sendPrivateMessage(to peer: ChatPeer? = nil) {
        let targetPeer = peer ?? selectedPeer
        guard let targetPeer else { return }

        let text = privateInputText
        networkService.sendPrivate(text: text, to: targetPeer)

        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            privateInputText = ""
        }
    }
    
    func openChat(with peer: ChatPeer) {
        isPeersScreenPresented = false
        selectedPeer = peer
        
    }

    func getMessages(for peer: ChatPeer) -> [ChatMessage] {
        privateMessages[peer.id, default: []]
        
    }
}

// MARK: - Конфигурация экрана

extension ChatScreenViewModel {
    static func directChat(
        participant: ChatParticipant,
        subtitle: String,
        messages: [ChatMessage] = [],
        emptyState: ChatEmptyState? = nil,
        composerPlaceholder: String = String(localized: "Сообщение...")
    ) -> ChatScreenViewModel {
        ChatScreenViewModel(
            networkService: MPCNetworkService(), headerStyle: .direct(participant: participant, subtitle: subtitle),
            messages: messages,
            emptyState: emptyState,
        )
    }

    static func groupChat(
        title: String,
        participantsSubtitle: String,
        messages: [ChatMessage],
        timelineTitle: String? = nil,
        composerPlaceholder: String = String(localized: "Сообщение всем...")
    ) -> ChatScreenViewModel {
        ChatScreenViewModel(
            networkService: MPCNetworkService(), headerStyle: .group(title: title, subtitle: participantsSubtitle),
            timelineTitle: timelineTitle,
            messages: messages,
        )
    }

    static let empty = ChatScreenViewModel(
        networkService: MPCNetworkService(), headerStyle: .group(title: String(localized: "Чат"), subtitle: ""),
        messages: [],
    )
}

// MARK: - Иммутабельные изменения конфигурации

extension ChatScreenViewModel {
    func appendingOutgoingMessage(text: String, time: String) -> ChatScreenViewModel {
        let newMessage = ChatMessage(
            sender: .outgoing,
            text: text,
            time: time
        )

        return ChatScreenViewModel(
            networkService: MPCNetworkService(), headerStyle: headerStyle,
            timelineTitle: timelineTitle,
            messages: messages + [newMessage],
            emptyState: nil,
        )
    }
}
