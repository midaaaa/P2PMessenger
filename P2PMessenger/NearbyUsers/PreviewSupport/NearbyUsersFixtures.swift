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
        NearbyUserRowViewModel(id: "1", name: "Вася", connectionStatus: .connected),
        NearbyUserRowViewModel(id: "2", name: "Глеб", connectionStatus: .connecting),
        NearbyUserRowViewModel(id: "3", name: "Кирилл", connectionStatus: .notConnected),
        NearbyUserRowViewModel(id: "4", name: "Маша", connectionStatus: .connected)
    ]
}
