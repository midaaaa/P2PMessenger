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
    @Test // отправляет три разных соо и чекает, чтобы они прошли именно в нужные им чаты
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

    @Test // проверяет все кейсы, что текстовые ошибки соотвествуют реальным
    func networkServiceErrorDescriptions_matchUserFacingCopy() {
        #expect(NetworkServiceError.emptyMessage.errorDescription == "Сообщение пустое")
        #expect(NetworkServiceError.noConnectedPeers.errorDescription == "Нет подключённых устройств рядом")
        #expect(NetworkServiceError.peerUnavailable.errorDescription == "Устройство недоступно или ещё не подключено")
        #expect(NetworkServiceError.invalidDisplayName.errorDescription == "Имя должно содержать от 1 до 30 символов")
        #expect(NetworkServiceError.transportFailure("boom").errorDescription == "Ошибка сети: boom")
        #expect(NetworkServiceError.invalidInvitation.errorDescription == "Получено некорректное приглашение к подключению")
    }

    @Test // проверяет имя пользователя на адекатность
    func validatedDisplayName_trimsCollapsesWhitespaceAndLimitsLength() {
        #expect(MPCNetworkServiceImpl.validatedDisplayName("   ") == nil)
        #expect(MPCNetworkServiceImpl.validatedDisplayName("   Alice   Bob  ") == "Alice Bob")

        let longName = String(repeating: "a", count: MPCNetworkConstants.maxDisplayNameLength + 10)
        let validated = MPCNetworkServiceImpl.validatedDisplayName(longName)
        #expect(validated?.count == MPCNetworkConstants.maxDisplayNameLength)
    }

    @Test // проверяет защиту сериализации сетевого протокола, чтобы обе стороны могли свои пакеты расшифровать
    func wirePacketFactories_fillExpectedPayloadSlot() {
        let wire = WireMessageDTO(
            id: UUID(),
            text: "hello",
            senderID: "a",
            senderDisplayName: "Alice",
            recipientID: nil,
            recipientDisplayName: nil,
            timestamp: .distantPast
        )
        let hello = HelloMessageDTO(
            senderID: "a",
            senderDisplayName: "Alice",
            leaderID: "a",
            clusterSize: 2,
            groupEpoch: 5
        )

        let chatPacket = WirePacketDTO.chat(wire)
        let helloPacket = WirePacketDTO.hello(hello)

        #expect(chatPacket.kind == "chat")
        #expect(chatPacket.chat?.id == wire.id)
        #expect(chatPacket.chat?.text == wire.text)
        #expect(chatPacket.hello == nil)

        #expect(helloPacket.kind == "hello")
        #expect(helloPacket.hello?.senderID == hello.senderID)
        #expect(helloPacket.hello?.leaderID == hello.leaderID)
        #expect(helloPacket.chat == nil)
    }
}
