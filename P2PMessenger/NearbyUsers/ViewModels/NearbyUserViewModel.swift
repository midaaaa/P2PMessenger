//
//  NearbyUserViewModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 03.04.2026.
//

import Foundation

@Observable
final class NearbyUserViewModel {
    private(set) var users: [NearbyUserRowViewModel]
    private(set) var isScanning: Bool = true
    
    init(users: [NearbyUserRowViewModel], isScanning: Bool) {
        self.users = users
        self.isScanning = isScanning
    }
}

