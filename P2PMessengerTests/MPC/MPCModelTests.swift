//
//  MPCModelTests.swift
//  P2PMessenger
//
//  Created by Екатерина on 08.04.2026.
//

import Foundation
import Testing
@testable import P2PMessenger

struct MPCModelTests {
    @Test
    func coreChatMessageConversationPeerID_resolvesPrivateIncomingAndOutgoingMessages() {
        let incoming = makeMessage(
            senderID: "alice",
            senderDisplayName: "Alice",
            recipientID: "local",
            recipientDisplayName: "Me",
            timestamp: .distantPast,
            isIncoming: true
        )
        let outgoing = makeMessage(
            senderID: "local",
            senderDisplayName: "Me",
            recipientID: "alice",
            recipientDisplayName: "Alice",
            timestamp: .distantPast,
            isIncoming: false
        )
        let common = makeMessage(
            senderID: "alice",
            senderDisplayName: "Alice",
            timestamp: .distantPast,
            isIncoming: true
        )

        #expect(incoming.conversationPeerID == "alice")
        #expect(outgoing.conversationPeerID == "alice")
        #expect(common.conversationPeerID == nil)
    }

    @Test
    func networkServiceErrorDescriptions_matchUserFacingCopy() {
        #expect(NetworkServiceError.emptyMessage.errorDescription == "Сообщение пустое")
        #expect(NetworkServiceError.noConnectedPeers.errorDescription == "Нет подключённых устройств рядом")
        #expect(NetworkServiceError.peerUnavailable.errorDescription == "Устройство недоступно или ещё не подключено")
        #expect(NetworkServiceError.invalidDisplayName.errorDescription == "Имя должно содержать от 1 до 30 символов")
        #expect(NetworkServiceError.transportFailure("boom").errorDescription == "Ошибка сети: boom")
        #expect(NetworkServiceError.invalidInvitation.errorDescription == "Получено некорректное приглашение к подключению")
    }

    @Test
    func validatedDisplayName_trimsCollapsesWhitespaceAndLimitsLength() {
        #expect(LocalPeerIdentityProvider.validatedDisplayName("   ") == nil)
        #expect(LocalPeerIdentityProvider.validatedDisplayName("   Alice   Bob  ") == "Alice Bob")

        let longName = String(repeating: "a", count: MPCNetworkConstants.maxDisplayNameLength + 10)
        let validated = LocalPeerIdentityProvider.validatedDisplayName(longName)

        #expect(validated?.count == MPCNetworkConstants.maxDisplayNameLength)
    }

    @Test
    func wirePacketFactories_fillExpectedPayloadSlot() {
        let wire = WireMessageDTO(
            id: UUID(),
            text: "hello",
            senderID: "alice",
            senderDisplayName: "Alice",
            recipientID: nil,
            recipientDisplayName: nil,
            timestamp: .distantPast
        )

        let hello = HelloMessageDTO(
            senderID: "alice",
            senderDisplayName: "Alice",
            leaderID: "alice",
            clusterSize: 1,
            groupEpoch: 1
        )

        let chatPacket = WirePacketDTO.chat(wire)
        #expect(chatPacket.kind == "chat")
        #expect(chatPacket.hello == nil)
        #expect(chatPacket.chat?.id == wire.id)
        #expect(chatPacket.chat?.text == wire.text)
        #expect(chatPacket.chat?.senderID == wire.senderID)
        #expect(chatPacket.chat?.senderDisplayName == wire.senderDisplayName)
        #expect(chatPacket.chat?.recipientID == wire.recipientID)
        #expect(chatPacket.chat?.recipientDisplayName == wire.recipientDisplayName)
        #expect(chatPacket.chat?.timestamp == wire.timestamp)
        
        let helloPacket = WirePacketDTO.hello(hello)
        #expect(helloPacket.kind == "hello")
        #expect(helloPacket.chat == nil)
        #expect(helloPacket.hello?.senderID == hello.senderID)
        #expect(helloPacket.hello?.senderDisplayName == hello.senderDisplayName)
        #expect(helloPacket.hello?.leaderID == hello.leaderID)
        #expect(helloPacket.hello?.clusterSize == hello.clusterSize)
        #expect(helloPacket.hello?.groupEpoch == hello.groupEpoch)
    }
}
