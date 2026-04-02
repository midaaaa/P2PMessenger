//
//  ChatScreenViewModel.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import Foundation
import Observation

// MARK: - Состояние и действия экрана чата

@Observable
final class ChatScreenViewModel {
    var draftMessage = ""
    private(set) var configuration: ChatScreenConfiguration

    init(configuration: ChatScreenConfiguration = .empty) {
        self.configuration = configuration
    }

    // MARK: - Отправка сообщения от текущего пользователя

    func sendMessage(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        configuration = configuration.appendingOutgoingMessage(
            text: trimmedText,
            time: Self.messageTimeFormatter.string(from: Date())
        )
        draftMessage = ""
    }

    // MARK: - Форматирование времени новых сообщений

    private static let messageTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
