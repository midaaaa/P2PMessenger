//
//  networkServiceError.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation

enum NetworkServiceError: LocalizedError, Equatable {
    case emptyMessage
    case noConnectedPeers
    case peerUnavailable
    case invalidDisplayName
    case transportFailure(String)
    case invalidInvitation

    var errorDescription: String? {
        switch self {
        case .emptyMessage:
            return "Сообщение пустое"
        case .noConnectedPeers:
            return "Нет подключённых устройств рядом"
        case .peerUnavailable:
            return "Устройство недоступно или ещё не подключено"
        case .invalidDisplayName:
            return "Имя должно содержать от 1 до 30 символов"
        case let .transportFailure(details):
            return "Ошибка сети: \(details)"
        case .invalidInvitation:
            return "Получено некорректное приглашение к подключению"
        }
    }
}
