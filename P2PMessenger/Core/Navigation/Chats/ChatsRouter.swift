//
//  ChatsRouter.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 03.04.2026.
//


import Observation

@Observable
final class ChatsRouter {
    var path: [ChatsRoute] = []

    func push(_ route: ChatsRoute) {
        path.append(route)
    }

    func popToRoot() {
        path.removeAll()
    }
}