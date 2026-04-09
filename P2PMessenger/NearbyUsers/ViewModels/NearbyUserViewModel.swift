//
//  NearbyUserViewModel.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 03.04.2026.
//

import Foundation

/// Преобразует пир-состояние из PeerSessionCoordinator в UI-модель для NearbyUsersView.
/// Не держит собственного сетевого состояния — всё читается реактивно из coordinator.
@MainActor
@Observable
final class NearbyUserViewModel {

    private let coordinator: PeerSessionCoordinatorProtocol

    init(coordinator: PeerSessionCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    // MARK: - Computed UI state

    var users: [NearbyUserRowViewModel] {
        let connectedIDs = Set(coordinator.connectedPeers.map(\.id))
        let connectingIDs = Set(coordinator.connectingPeers.map(\.id))

        return coordinator.discoveredPeers.map { peer in
            let status: ConnectionStatus
            if connectedIDs.contains(peer.id)       { status = .connected }
            else if connectingIDs.contains(peer.id) { status = .connecting }
            else                                     { status = .notConnected }
            return NearbyUserRowViewModel(id: peer.id, name: peer.displayName, connectionStatus: status)
        }
    }

    var isScanning: Bool { coordinator.isRunning }
}
