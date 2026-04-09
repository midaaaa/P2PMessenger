//
//  ChatViewModelTests.swift
//  P2PMessenger
//
//  Created by Екатерина on 08.04.2026.
//


import Foundation
import Testing
@testable import P2PMessenger

struct ChatViewModelTests {
    @Test //проверяет восстановление истории на уровне вьюмодельки
    @MainActor
    func init_restoresPersistedMessagesSortedAndTracksSeenIDs() throws {
        let defaults = makeDefaults()
        let service = MPCNetworkServiceImpl(defaults: defaults)
        let meshMessages = [
            makeMessage(id: UUID(), text: "later", senderID: "b", senderDisplayName: "B", timestamp: .now, isIncoming: true),
            makeMessage(id: UUID(), text: "earlier", senderID: "a", senderDisplayName: "A", timestamp: .distantPast, isIncoming: true)
        ]
        let privateMessages = [
            "peer": [
                makeMessage(id: UUID(), text: "second", senderID: "peer", senderDisplayName: "Peer", recipientID: service.localPeer.id, recipientDisplayName: service.localPeer.displayName, timestamp: .now, isIncoming: true),
                makeMessage(id: UUID(), text: "first", senderID: service.localPeer.id, senderDisplayName: service.localPeer.displayName, recipientID: "peer", recipientDisplayName: "Peer", timestamp: .distantPast, isIncoming: false)
            ]
        ]
        defaults.set(try JSONEncoder().encode(meshMessages), forKey: "chat.mesh.messages")
        defaults.set(try JSONEncoder().encode(privateMessages), forKey: "chat.private.messages")

        let viewModel = ChatViewModel(networkService: service, defaults: defaults)

        #expect(viewModel.meshMessages.map(\.text) == ["earlier", "later"])
        #expect(viewModel.messages(for: makePeer(id: "peer", name: "Peer")).map(\.text) == ["first", "second"])
    }

    @Test //проверяет удобность отправки личного соо (чтобы текст стирался, только если реально отправился кому-то)
    @MainActor
    func sendPrivateMessage_requiresTargetPeer_andClearsOnlyNonWhitespaceInput() {
        let defaults = makeDefaults()
        let service = MPCNetworkServiceImpl(defaults: defaults)
        let viewModel = ChatViewModel(networkService: service, defaults: defaults)
        let peer = makePeer(id: "peer", name: "Peer")

        viewModel.privateInputText = "hello"
        viewModel.sendPrivateMessage()
        #expect(viewModel.privateInputText == "hello")

        viewModel.selectedPeer = peer
        viewModel.privateInputText = "   \n"
        viewModel.sendPrivateMessage()
        #expect(viewModel.privateInputText == "   \n")

        viewModel.privateInputText = "hello"
        viewModel.sendPrivateMessage()
        #expect(viewModel.privateInputText.isEmpty)
    }

    @Test //проверяет переход между экранами и сброс жизненного цикла (открытие чата должно закрывать модалку пирс и уход в бек должен сбрасывать сетевое состояние вьюмодели)
    @MainActor
    func openChatAndBackgroundLifecycle_updateScreenState() {
        let defaults = makeDefaults()
        let service = MPCNetworkServiceImpl(defaults: defaults)
        let viewModel = ChatViewModel(networkService: service, defaults: defaults)
        let peer = makePeer(id: "peer", name: "Peer")

        viewModel.isPeersScreenPresented = true
        viewModel.openChat(with: peer)
        #expect(!viewModel.isPeersScreenPresented)
        #expect(viewModel.selectedPeer == peer)

        viewModel.startIfNeeded()
        #expect(viewModel.isNetworkReady)
        viewModel.appMovedToBackground()
        #expect(!viewModel.isNetworkReady)
        #expect(viewModel.discoveredPeers.isEmpty)
        #expect(viewModel.connectedPeers.isEmpty)
        #expect(viewModel.connectingPeers.isEmpty)
    }

    @Test //проверяет обработку входящих сообщений во вьюмодель (чтобы переписки не мешались в чате)
    @MainActor
    func didReceive_appendsRelevantMessages_andFiltersForeignPrivateConversation() {
        let defaults = makeDefaults()
        let service = MPCNetworkServiceImpl(defaults: defaults)
        let viewModel = ChatViewModel(networkService: service, defaults: defaults)

        let common = makeMessage(text: "mesh", senderID: "a", senderDisplayName: "A", timestamp: .distantPast, isIncoming: true)
        let privateToMe = makeMessage(text: "dm", senderID: "peer", senderDisplayName: "Peer", recipientID: service.localPeer.id, recipientDisplayName: service.localPeer.displayName, timestamp: .now, isIncoming: true)
        let privateForeign = makeMessage(text: "skip", senderID: "peer", senderDisplayName: "Peer", recipientID: "other", recipientDisplayName: "Other", timestamp: .now, isIncoming: true)

        viewModel.networkService(service, didReceive: common)
        viewModel.networkService(service, didReceive: privateToMe)
        viewModel.networkService(service, didReceive: privateForeign)

        #expect(viewModel.meshMessages.map(\.text) == ["mesh"])
        #expect(viewModel.privateMessages["peer"]?.map(\.text) == ["dm"])
    }

    @Test //проверяет реакцию вьюмодели на коллбеки, 
    @MainActor
    func peerAndErrorCallbacks_keepSelectionFresh_andExposeBanner() {
        let defaults = makeDefaults()
        let service = MPCNetworkServiceImpl(defaults: defaults)
        let viewModel = ChatViewModel(networkService: service, defaults: defaults)
        let selected = makePeer(id: "peer", name: "Old")
        let updated = makePeer(id: "peer", name: "New")

        viewModel.selectedPeer = selected
        viewModel.networkService(service, peersChanged: [updated])
        #expect(viewModel.selectedPeer == updated)

        viewModel.networkService(service, connectedPeersChanged: [updated])
        #expect(viewModel.isPeerConnected(updated))

        viewModel.networkService(service, peersChanged: [])
        #expect(viewModel.selectedPeer == updated)

        viewModel.networkService(service, connectedPeersChanged: [])
        viewModel.networkService(service, peersChanged: [])
        #expect(viewModel.selectedPeer == nil)

        viewModel.networkService(service, connectingPeersChanged: [updated])
        #expect(viewModel.isPeerConnecting(updated))

        viewModel.networkService(service, didUpdateLocalPeer: makePeer(id: service.localPeer.id, name: "Renamed"))
        #expect(viewModel.localPeerName == "Renamed")
        #expect(viewModel.editableName == "Renamed")

        viewModel.networkService(service, didEncounter: .peerUnavailable)
        #expect(viewModel.bannerText == NetworkServiceError.peerUnavailable.errorDescription)
        viewModel.clearBanner()
        #expect(viewModel.bannerText == nil)
    }
}
