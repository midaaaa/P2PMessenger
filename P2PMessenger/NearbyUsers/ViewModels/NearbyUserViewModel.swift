//
//  NearbyUserViewModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 03.04.2026.
//

import Foundation

@Observable
final class NearbyUserViewModel {
    var users: [NearbyUserModel] = stubNearbyUsers
    var isScanning: Bool = true
}

// MARK: - Stubs

private extension NearbyUserViewModel {
    static let stubNearbyUsers: [NearbyUserModel] = [
        NearbyUserModel(id: UUID(), name: "Вася", isOnline: true),
        NearbyUserModel(id: UUID(), name: "Глеб", isOnline: true),
        NearbyUserModel(id: UUID(), name: "Кирилл", isOnline: false),
        NearbyUserModel(id: UUID(), name: "Маша", isOnline: true)
    ]
}
