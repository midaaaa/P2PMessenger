//
//  CommonChatCoordinatorTests.swift
//  P2PMessenger
//
//  Created by Екатерина on 08.04.2026.
//


import Foundation
import Testing
@testable import P2PMessenger

struct CommonChatCoordinatorTests {
    @Test // проверяет восстановление истории общего чата из UserDefaults на корректность
    @MainActor
    func init_restoresSortedTrimmedPersistedMessages() throws {
        let defaults = makeDefaults()
        let (service, peerCoordinator) = makeServiceAndCoordinator(defaults: defaults)

        let base = Date(timeIntervalSince1970: 1_000)
        let messages = (0..<305).map { index in
            makeMessage(
                id: UUID(),
                text: "m\(index)",
                senderID: index.isMultiple(of: 2) ? service.localPeer.id : "remote",
                senderDisplayName: index.isMultiple(of: 2) ? service.localPeer.displayName : "Remote",
                timestamp: base.addingTimeInterval(Double(305 - index)),
                isIncoming: !index.isMultiple(of: 2)
            )
        }
        let encoded = try JSONEncoder().encode(messages)
        defaults.set(encoded, forKey: "chat.common.messages")

        let coordinator = CommonChatCoordinator(networkService: service, peerCoordinator: peerCoordinator, defaults: defaults)

        #expect(coordinator.chatMessages.count == 300)
        let restoredTexts = coordinator.chatMessages.map(\.text)
        #expect(restoredTexts.first == "m299")
        #expect(restoredTexts.last == "m0")
    }

    @Test // проверяет фильтрацию соо в общий чат, чтобы туда не попадали дубликаты и личные
    @MainActor
    func ignoresPrivateAndDuplicateMessages_butAcceptsPublicOnes() {
        let defaults = makeDefaults()
        let (service, peerCoordinator) = makeServiceAndCoordinator(defaults: defaults)
        let coordinator = CommonChatCoordinator(networkService: service, peerCoordinator: peerCoordinator, defaults: defaults)
        let id = UUID()
        let publicMessage = makeMessage(
            id: id,
            text: "public",
            senderID: "remote",
            senderDisplayName: "Remote",
            timestamp: .distantPast,
            isIncoming: true
        )
        let duplicate = makeMessage(
            id: id,
            text: "duplicate",
            senderID: "remote",
            senderDisplayName: "Remote",
            timestamp: .now,
            isIncoming: true
        )
        let privateMessage = makeMessage(
            text: "private",
            senderID: "remote",
            senderDisplayName: "Remote",
            recipientID: service.localPeer.id,
            recipientDisplayName: service.localPeer.displayName,
            timestamp: .now,
            isIncoming: true
        )

        peerCoordinator.networkService(service, didReceive: publicMessage)
        peerCoordinator.networkService(service, didReceive: duplicate)
        peerCoordinator.networkService(service, didReceive: privateMessage)

        #expect(coordinator.chatMessages.map(\.text) == ["public"])
    }

    @Test // проверяет преобразование модельки в UI, чтобы тот не ломался и корректно показывал автора сообщения и его состояние
    @MainActor
    func chatMessages_mapOutgoingIncomingAndOnlineStatus() {
        let defaults = makeDefaults()
        let (service, peerCoordinator) = makeServiceAndCoordinator(defaults: defaults)
        let coordinator = CommonChatCoordinator(networkService: service, peerCoordinator: peerCoordinator, defaults: defaults)
        let remote = makePeer(id: "remote", name: "Remote")

        peerCoordinator.networkService(service, connectedPeersChanged: [remote])
        peerCoordinator.networkService(service, didReceive: makeMessage(
            text: "mine",
            senderID: service.localPeer.id,
            senderDisplayName: service.localPeer.displayName,
            timestamp: Date(timeIntervalSince1970: 10),
            isIncoming: false
        ))
        peerCoordinator.networkService(service, didReceive: makeMessage(
            text: "theirs",
            senderID: remote.id,
            senderDisplayName: remote.displayName,
            timestamp: Date(timeIntervalSince1970: 20),
            isIncoming: true
        ))

        let messages = coordinator.chatMessages
        #expect(messages.count == 2)
        #expect(messages[0].isOutgoing)
        #expect(messages[1].incomingParticipant?.name == "Remote")
        #expect(messages[1].incomingParticipant?.isOnline == true)
    }

    @Test // проверяет как работает эта надпись "участник/а/ов" с разным количеством юзеров
    @MainActor
    func headerStyle_usesRussianPluralizationBasedOnConnectedPeers() {
        let defaults = makeDefaults()
        let (service, peerCoordinator) = makeServiceAndCoordinator(defaults: defaults)
        let coordinator = CommonChatCoordinator(networkService: service, peerCoordinator: peerCoordinator, defaults: defaults)

        func subtitle() -> String {
            switch coordinator.headerStyle {
            case .group(_, let subtitle): return subtitle
            case .direct: return ""
            }
        }

        #expect(subtitle() == "1 участник")

        peerCoordinator.networkService(service, connectedPeersChanged: [
            makePeer(id: "a", name: "A")
        ])
        #expect(subtitle() == "2 участника")

        peerCoordinator.networkService(service, connectedPeersChanged: [
            makePeer(id: "a", name: "A"),
            makePeer(id: "b", name: "B"),
            makePeer(id: "c", name: "C"),
            makePeer(id: "d", name: "D")
        ])
        #expect(subtitle() == "5 участников")
        #expect(coordinator.chatTimelineTitle == "Сегодня Общий чат")
    }
}
