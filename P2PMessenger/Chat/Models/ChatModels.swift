//
//  ChatModels.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import Foundation

// MARK: - Базовые сущности чата

struct ChatParticipant: Identifiable, Hashable {
    let id: UUID
    let name: String
    let avatarInitial: String
    let isOnline: Bool

    init(
        id: UUID = UUID(),
        name: String,
        avatarInitial: String? = nil,
        isOnline: Bool
    ) {
        self.id = id
        self.name = name
        self.avatarInitial = ChatParticipant.resolveInitial(for: name, preferred: avatarInitial)
        self.isOnline = isOnline
    }

    private static func resolveInitial(for name: String, preferred: String?) -> String {
        if let preferred, !preferred.isEmpty {
            return preferred
        }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let firstCharacter = trimmedName.first.map { String($0).uppercased() }
        return firstCharacter ?? "?"
    }
}

enum ChatHeaderStyle: Hashable {
    case direct(participant: ChatParticipant, subtitle: String)
    case group(title: String, subtitle: String)
}

enum ChatMessageSender: Hashable {
    case incoming(ChatParticipant)
    case outgoing
}

struct ChatMessage: Identifiable, Hashable {
    let id: UUID
    let sender: ChatMessageSender
    let text: String
    let time: String

    init(
        id: UUID = UUID(),
        sender: ChatMessageSender,
        text: String,
        time: String
    ) {
        self.id = id
        self.sender = sender
        self.text = text
        self.time = time
    }
}

struct ChatEmptyState: Hashable {
    let participant: ChatParticipant
    let title: String
    let subtitle: String
}

// MARK: - Вычисляемые свойства сообщения

extension ChatMessage {
    var incomingParticipant: ChatParticipant? {
        guard case let .incoming(participant) = sender else { return nil }
        return participant
    }

    var isOutgoing: Bool {
        guard case .outgoing = sender else { return false }
        return true
    }
}
