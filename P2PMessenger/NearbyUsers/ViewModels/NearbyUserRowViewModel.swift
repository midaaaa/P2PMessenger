//
//  NearbyUserRowViewModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 03.04.2026.
//

import Foundation

enum ConnectionStatus {
    case connecting
    case connected
    case notConnected

    var displayName: String {
        switch self {
        case .connecting:   return String(localized: "nearby_user_connecting_status")
        case .connected:    return String(localized: "nearby_user_connected_status")
        case .notConnected: return String(localized: "nearby_user_not_connected_status")
        }
    }
}

struct NearbyUserRowViewModel: Identifiable {
    let id: String
    var name: String
    var connectionStatus: ConnectionStatus
}
