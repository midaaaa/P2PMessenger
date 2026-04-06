//
//  IdentityViewModel.swift
//  P2PMessenger
//

import Foundation

/// Отвечает за идентификацию локального пользователя:
/// отображение имени и его изменение через MPCNetworkService.
@MainActor
@Observable
final class IdentityViewModel {

    var editableName: String
    var isRenameAlertPresented = false

    var localPeer: ChatPeer { coordinator.localPeer }

    private let networkService: MPCNetworkService
    private let coordinator: PeerSessionCoordinator

    init(networkService: MPCNetworkService, coordinator: PeerSessionCoordinator) {
        self.networkService = networkService
        self.coordinator = coordinator
        self.editableName = coordinator.localPeer.displayName
    }

    func saveNewName() {
        networkService.updateDisplayName(editableName)
    }
}
