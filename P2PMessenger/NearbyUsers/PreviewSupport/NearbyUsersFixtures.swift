//
//  NearbyUsersFixtures.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 06.04.2026.
//

import SwiftUI

// MARK: - Stubs
enum NearbyUsersFixtures {
    static let stubNearbyUsers: [NearbyUserRowViewModel] = [
        NearbyUserRowViewModel(id: UUID(), name: "Вася", isOnline: true, connectionStatus: .connected),
        NearbyUserRowViewModel(id: UUID(), name: "Глеб", isOnline: true,  connectionStatus: .connecting),
        NearbyUserRowViewModel(id: UUID(), name: "Кирилл", isOnline: false, connectionStatus: .notConnected),
        NearbyUserRowViewModel(id: UUID(), name: "Маша", isOnline: true,  connectionStatus: .connected)
    ]
}
