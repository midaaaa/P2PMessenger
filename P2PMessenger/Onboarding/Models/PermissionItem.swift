//
//  PermissionItem.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 01.04.2026.
//

struct PermissionItem: Identifiable {
    let id: PermissionType
    let title: String
    let icon: String
    var state: PermissionState
}
