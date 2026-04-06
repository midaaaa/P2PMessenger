//
//  DependencyContainer.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class DependencyContainer {
    @ObservationIgnored let notificationService: NotificationServiceProtocol
    @ObservationIgnored let router: AppRouter

    // MARK: - Network layer
    @ObservationIgnored let networkService: MPCNetworkService
    @ObservationIgnored let coordinator: PeerSessionCoordinator

    // MARK: - Data layer
    @ObservationIgnored let messageStore: MessageStore

    // MARK: - ViewModels
    @ObservationIgnored let nearbyUserViewModel: NearbyUserViewModel
    @ObservationIgnored let meshChatViewModel: MeshChatViewModel
    @ObservationIgnored let identityViewModel: IdentityViewModel

    init(
        notificationService: NotificationServiceProtocol = NotificationService(),
        router: AppRouter = AppRouter()
    ) {
        self.notificationService = notificationService
        self.router = router

        let svc = MPCNetworkService()
        let coord = PeerSessionCoordinator(networkService: svc)
        let store = MessageStore(coordinator: coord)

        self.networkService = svc
        self.coordinator = coord
        self.messageStore = store

        self.nearbyUserViewModel = NearbyUserViewModel(coordinator: coord)
        self.meshChatViewModel = MeshChatViewModel(networkService: svc, coordinator: coord, store: store)
        self.identityViewModel = IdentityViewModel(networkService: svc, coordinator: coord)
    }
}
