//
//  NearbyUserModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 03.04.2026.
//

import Foundation

struct NearbyUserModel: Identifiable {
    let id: UUID
    var name: String
    var isOnline: Bool
}
