//
//  PeerSessionCoordinator.swift
//  P2PMessenger
//

import Foundation

/// Единственный владелец делегата MPCNetworkService.
/// Мультикастит события сети всем подписчикам через subscribe(onMessage:).
/// Все VM читают пир-состояние напрямую через @Observable.
@MainActor
@Observable
final class PeerSessionCoordinator {

    // MARK: - Peer state (публичное @Observable состояние)

    private(set) var localPeer: ChatPeer
    private(set) var discoveredPeers: [ChatPeer] = []
    private(set) var connectedPeers: [ChatPeer] = []
    private(set) var connectingPeers: [ChatPeer] = []
    private(set) var isRunning = false
    private(set) var latestError: NetworkServiceError?

    // MARK: - Private

    private let networkService: MPCNetworkService
    private var messageHandlers: [(CoreChatMessage) -> Void] = []
    private var peerStateHandlers: [() -> Void] = []

    // MARK: - Init

    init(networkService: MPCNetworkService) {
        self.networkService = networkService
        self.localPeer = networkService.localPeer
        networkService.delegate = self
    }

    // MARK: - Lifecycle

    func startIfNeeded() {
        networkService.startIfNeeded()
        isRunning = true
    }

    func appBecameActive() {
        networkService.resumeIfNeeded()
        isRunning = true
    }

    func appMovedToBackground() {
        networkService.suspendForBackground()
        isRunning = false
        discoveredPeers = []
        connectedPeers = []
        connectingPeers = []
    }

    // MARK: - Peer queries

    func isPeerConnected(_ peer: ChatPeer) -> Bool {
        connectedPeers.contains { $0.id == peer.id }
    }

    func isPeerConnecting(_ peer: ChatPeer) -> Bool {
        connectingPeers.contains { $0.id == peer.id }
    }

    // MARK: - Message subscription

    /// Регистрирует обработчик входящих сообщений.
    /// Вызывается любым числом подписчиков; все получат каждое сообщение.
    func subscribe(onMessage handler: @escaping (CoreChatMessage) -> Void) {
        messageHandlers.append(handler)
    }

    func subscribePeerStateChanges(_ handler: @escaping () -> Void) {
        peerStateHandlers.append(handler)
    }

    func clearError() {
        latestError = nil
    }

    private func notifyPeerStateChanged() {
        for handler in peerStateHandlers { handler() }
    }
}

// MARK: - MPCNetworkServiceDelegate

extension PeerSessionCoordinator: MPCNetworkServiceDelegate {
    func networkService(_ service: MPCNetworkService, didReceive message: CoreChatMessage) {
        for handler in messageHandlers { handler(message) }
    }

    func networkService(_ service: MPCNetworkService, peersChanged peers: [ChatPeer]) {
        discoveredPeers = peers
        notifyPeerStateChanged()
    }

    func networkService(_ service: MPCNetworkService, connectedPeersChanged peers: [ChatPeer]) {
        connectedPeers = peers
        notifyPeerStateChanged()
    }

    func networkService(_ service: MPCNetworkService, connectingPeersChanged peers: [ChatPeer]) {
        connectingPeers = peers
        notifyPeerStateChanged()
    }

    func networkService(_ service: MPCNetworkService, didUpdateLocalPeer peer: ChatPeer) {
        localPeer = peer
    }

    func networkService(_ service: MPCNetworkService, didEncounter error: NetworkServiceError) {
        latestError = error
    }
}
