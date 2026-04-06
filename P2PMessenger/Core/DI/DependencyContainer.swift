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

    /// Единственный владелец делегата MPCNetworkService.
    /// Коллеги могут подписаться на сообщения через coordinator.subscribe(onMessage:).
    @ObservationIgnored let coordinator: PeerSessionCoordinator

    // MARK: - ViewModels
    @ObservationIgnored let nearbyUserViewModel: NearbyUserViewModel

    init(
        notificationService: NotificationServiceProtocol = NotificationService(),
        router: AppRouter = AppRouter()
    ) {
        self.notificationService = notificationService
        self.router = router

        let svc = MPCNetworkService()
        let coord = PeerSessionCoordinator(networkService: svc)

        self.networkService = svc
        self.coordinator = coord
        self.nearbyUserViewModel = NearbyUserViewModel(coordinator: coord)
    }
}
