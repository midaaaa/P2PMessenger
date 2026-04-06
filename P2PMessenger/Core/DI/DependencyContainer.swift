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

    @ObservationIgnored
    let bluetoothMonitor: BluetoothMonitor
    @ObservationIgnored
    let bluetoothStatusViewModel: BluetoothStatusViewModel
    @ObservationIgnored
    let chatsRootViewModel: ChatsRootViewModel
    
    init(notificationService: NotificationServiceProtocol = NotificationService(),
         router: AppRouter = AppRouter(),
         bluetoothMonitor: BluetoothMonitor = BluetoothMonitor()) {
        self.router = router
        
        // Notification
        self.notificationService = notificationService
        
        // Bluetooth
        self.bluetoothMonitor = bluetoothMonitor
        self.bluetoothStatusViewModel = BluetoothStatusViewModel(monitor: bluetoothMonitor)
        
        // Network
        let svc = MPCNetworkService()
        let coord = PeerSessionCoordinator(networkService: svc)
        self.networkService = svc
        self.coordinator = coord
        
        // Nearby Users - using the one from HEAD (main) which requires coordinator
        self.nearbyUserViewModel = NearbyUserViewModel(coordinator: coord)
        
        // Chats - injecting nearbyUserViewModel
        self.chatsRootViewModel = ChatsRootViewModel(
            chatListViewModel: ChatsListViewModel(
                chats: ChatListPreviewFixtures.stubChats
            ),
            chatScreenViewModel: ChatPreviewFixtures.newChat,
            nearbyUserViewModel: nearbyUserViewModel
        )
    }
    }
}
