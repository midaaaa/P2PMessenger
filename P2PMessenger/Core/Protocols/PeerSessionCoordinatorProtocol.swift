//
//  PeerSessionCoordinatorProtocol.swift
//  P2PMessenger
//
//  Created by Antigravity on 08.04.2026.
//

import Foundation

@MainActor
protocol PeerSessionCoordinatorProtocol: AnyObject {
    var localPeer: ChatPeer { get }
    var discoveredPeers: [ChatPeer] { get }
    var connectedPeers: [ChatPeer] { get }
    var connectingPeers: [ChatPeer] { get }
    var isRunning: Bool { get }
    var latestError: NetworkServiceError? { get }

    func startIfNeeded()
    func appBecameActive()
    func appMovedToBackground()

    func isPeerConnected(_ peer: ChatPeer) -> Bool
    func isPeerConnecting(_ peer: ChatPeer) -> Bool
    func peer(withID id: String) -> ChatPeer?

    func sendPrivate(text: String, to peer: ChatPeer)

    func subscribe(onMessage handler: @escaping (CoreChatMessage) -> Void)
    func privateMessages(for peerID: String) -> [CoreChatMessage]
    func privateConversationSnapshots() -> [PeerSessionCoordinator.PrivateConversationSnapshot]

    func subscribePeerStateChanges(_ handler: @escaping () -> Void)
    func clearError()
}
