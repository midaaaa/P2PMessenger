//
//  NotificationServiceProtocol.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import Foundation

protocol NotificationServiceProtocol {
    func requestPermission() async -> Bool
    func sendMessage(title: String, message: String, subtitle: String, userInfo: [AnyHashable: Any])
    func sendPeopleCount(count: Int)
}

extension NotificationServiceProtocol {
    func sendMessage(title: String, message: String, subtitle: String = "", userInfo: [AnyHashable: Any] = [:]) {
        self.sendMessage(title: title, message: message, subtitle: subtitle, userInfo: userInfo)
    }
    func sendPeopleCount(count:Int) { self.sendPeopleCount(count: count)}
}
