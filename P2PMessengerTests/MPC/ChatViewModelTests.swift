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
    @Test
    @MainActor
    func init_restoresPersistedMeshMessagesSorted_andStartsWithEmptyPrivateMessages() {
        let defaults = makeDefaults()
        let historyStorage = makeHistoryStorage(defaults: defaults)
        let identityProvider = makeIdentityProvider(defaults: defaults)
        let service = MPCNetworkServiceImpl(identityProvider: identityProvider)

        let meshMessages = [
            makeMessage(id: UUID(), text: "later", senderID: "b", senderDisplayName: "B", timestamp: .now, isIncoming: true),
            makeMessage(id: UUID(), text: "earlier", senderID: "a", senderDisplayName: "A", timestamp: .distantPast, isIncoming: true)
        ]
        historyStorage.saveMeshMessages(meshMessages)

        let viewModel = ChatViewModel(
            networkService: service,
            identityProvider: identityProvider,
            historyStorage: historyStorage
        )

        #expect(viewModel.meshMessages.map(\.text) == ["earlier", "later"])
        #expect(viewModel.privateMessages.isEmpty)
        #expect(viewModel.messages(for: makePeer(id: "peer", name: "Peer")).isEmpty)
    }

    @Test
    @MainActor
    func sendPrivateMessage_requiresTargetPeer_andClearsOnlyNonWhitespaceInput() {
        let defaults = makeDefaults()
        let historyStorage = makeHistoryStorage(defaults: defaults)
        let identityProvider = makeIdentityProvider(defaults: defaults)
        let service = MPCNetworkServiceImpl(identityProvider: identityProvider)
        let viewModel = ChatViewModel(
            networkService: service,
            identityProvider: identityProvider,
            historyStorage: historyStorage
        )
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

    @Test
    @MainActor
    func openChatAndBackgroundLifecycle_updateScreenState() {
        let defaults = makeDefaults()
        let historyStorage = makeHistoryStorage(defaults: defaults)
        let identityProvider = makeIdentityProvider(defaults: defaults)
        let service = MPCNetworkServiceImpl(identityProvider: identityProvider)
        let viewModel = ChatViewModel(
            networkService: service,
            identityProvider: identityProvider,
            historyStorage: historyStorage
        )
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

    @Test
    @MainActor
    func didReceive_appendsRelevantMessages_andFiltersForeignPrivateConversation() {
        let defaults = makeDefaults()
        let historyStorage = makeHistoryStorage(defaults: defaults)
        let identityProvider = makeIdentityProvider(defaults: defaults)
        let service = MPCNetworkServiceImpl(identityProvider: identityProvider)
        let viewModel = ChatViewModel(
            networkService: service,
            identityProvider: identityProvider,
            historyStorage: historyStorage
        )

        let common = makeMessage(
            text: "mesh",
            senderID: "a",
            senderDisplayName: "A",
            timestamp: .distantPast,
            isIncoming: true
        )
        let privateToMe = makeMessage(
            text: "dm",
            senderID: "peer",
            senderDisplayName: "Peer",
            recipientID: service.localPeer.id,
            recipientDisplayName: service.localPeer.displayName,
            timestamp: .now,
            isIncoming: true
        )
        let privateForeign = makeMessage(
            text: "skip",
            senderID: "peer",
            senderDisplayName: "Peer",
            recipientID: "other",
            recipientDisplayName: "Other",
            timestamp: .now,
            isIncoming: true
        )

        viewModel.networkService(service, didReceive: common)
        viewModel.networkService(service, didReceive: privateToMe)
        viewModel.networkService(service, didReceive: privateForeign)

        #expect(viewModel.meshMessages.map(\.text) == ["mesh"])
        #expect(viewModel.privateMessages["peer"]?.map(\.text) == ["dm"])
    }

    @Test
    @MainActor
    func peerAndErrorCallbacks_keepSelectionFresh_andExposeBanner() {
        let defaults = makeDefaults()
        let historyStorage = makeHistoryStorage(defaults: defaults)
        let identityProvider = makeIdentityProvider(defaults: defaults)
        let service = MPCNetworkServiceImpl(identityProvider: identityProvider)
        let viewModel = ChatViewModel(
            networkService: service,
            identityProvider: identityProvider,
            historyStorage: historyStorage
        )

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
