//
//  NotificationService.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import Foundation
import UserNotifications

struct NotificationService: NotificationServiceProtocol {
    
    func requestPermission() async -> Bool {
        do {
            let success = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            return success
        } catch {
            print("Notification Exception: \(error.localizedDescription)")
            return false
        }
    }
    
    func isPermissionGranted() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }

    func sendMessage(title: String, message: String, subtitle: String = "", userInfo: [AnyHashable: Any] = [:]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = message
        content.userInfo = userInfo
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Scheduling Error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendPeopleCount(count: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Найдены новые собеседники!"
        content.body = "Найдено \(count) человек"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Scheduling Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Notification routing models (kept here to ensure target membership)

enum ChatDestination: Hashable, Codable {
    case common
    case `private`(peerID: String)
}

struct NotificationPayload: Hashable {
    static let destinationKey = "destination"
    static let peerIDKey = "peerID"

    let destination: ChatDestination

    init(destination: ChatDestination) {
        self.destination = destination
    }

    init?(userInfo: [AnyHashable: Any]) {
        guard let raw = userInfo[Self.destinationKey] as? String else { return nil }
        switch raw {
        case "common":
            self.destination = .common
        case "private":
            guard let peerID = userInfo[Self.peerIDKey] as? String else { return nil }
            self.destination = .private(peerID: peerID)
        default:
            return nil
        }
    }

    var userInfo: [AnyHashable: Any] {
        switch destination {
        case .common:
            return [Self.destinationKey: "common"]
        case .private(let peerID):
            return [
                Self.destinationKey: "private",
                Self.peerIDKey: peerID
            ]
        }
    }
}

@MainActor
final class ChatNotificationsController {
    private let appRouter: AppRouterProtocol
    private let notificationService: NotificationServiceProtocol

    init(
        peerCoordinator: PeerSessionCoordinatorProtocol,
        appRouter: AppRouterProtocol,
        notificationService: NotificationServiceProtocol
    ) {
        self.appRouter = appRouter
        self.notificationService = notificationService

        peerCoordinator.subscribe(onMessage: { [weak self] message in
            guard let self else { return }
            self.handle(message)
        })
    }

    private func handle(_ message: CoreChatMessage) {
        guard message.isIncoming else { return }

        let destination: ChatDestination
        if message.recipientID == nil {
            destination = .common
        } else if let peerID = message.conversationPeerID {
            destination = .private(peerID: peerID)
        } else {
            return
        }

        if appRouter.isAppActive, appRouter.activeDestination == destination {
            return
        }

        let title: String
        let subtitle: String
        switch destination {
        case .common:
            title = "Общий чат"
            subtitle = message.senderDisplayName
        case .private:
            title = message.senderDisplayName
            subtitle = ""
        }

        notificationService.send(
            title: title,
            message: message.text,
            subtitle: subtitle,
            userInfo: NotificationPayload(destination: destination).userInfo
        )
    }
}
