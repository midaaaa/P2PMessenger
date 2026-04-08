//
//  RootGraph.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import SwiftUI
import Observation

@Observable
final class RootGraph {
    // Services
    @ObservationIgnored
    let notificationService: NotificationServiceProtocol
    @ObservationIgnored
    let router: AppRouter
    @ObservationIgnored
    let bluetoothMonitor: BluetoothMonitor
    
    // Storage
    @ObservationIgnored let profileStorage: UserProfileStorageProtocol
    @ObservationIgnored let identityProvider: LocalPeerIdentityProvider
    @ObservationIgnored let onboardingState: OnboardingState

    // Network layer
    @ObservationIgnored let networkService: MPCNetworkServiceImpl
    @ObservationIgnored let coordinator: PeerSessionCoordinator

    
    // ViewModels
    @ObservationIgnored
    let bluetoothStatusViewModel: BluetoothStatusViewModel
    @ObservationIgnored
    let chatsRootViewModel: ChatsRootViewModel
    @ObservationIgnored
    let nearbyUserViewModel: NearbyUserViewModel
    @ObservationIgnored
    let welcomeScreenVM: WelcomeScreenVM
    @ObservationIgnored
    let commonChatViewModel: CommonChatViewModel
    @ObservationIgnored
    let settingsViewModel: SettingsViewModel
    
    // Notifications
    @ObservationIgnored
    private let chatNotifications: ChatNotificationsController
    
    // Views
    @ObservationIgnored
    var settingsRootView: SettingsRootView
    @ObservationIgnored
    var commonChatRootView: CommonChatRootView
    @ObservationIgnored
    var chatsRootView: ChatsRootView
    @ObservationIgnored
    var welcomeScreenView: WelcomeScreenView
    @ObservationIgnored
    var appRootView: AppRootView
    
    
    @MainActor
    init() {
        //AppRouter
        self.router = AppRouter()
        
        // Notification
        self.notificationService = NotificationService()
        
        // Bluetooth
        self.bluetoothMonitor = BluetoothMonitor()
        self.bluetoothStatusViewModel = BluetoothStatusViewModel(monitor: bluetoothMonitor)
        
        // Storage
        let baseStorage: KeyValueStorageProtocol = AppKeyValueStorage(defaults: .standard)
        let profileStorage = AppProfileStorage(storage: baseStorage)
        self.profileStorage = profileStorage
        
        let permissionsStorage = PermissionsStorage(storage: baseStorage)
        let onboardingStorage = OnboardingStorage(storage: baseStorage)
        self.onboardingState = OnboardingState(storage: onboardingStorage)
        let chatHistoryStorage = ChatHistoryStorage(storage: baseStorage)
        
        let identityProvider = LocalPeerIdentityProvider(profileStorage: profileStorage)
        self.identityProvider = identityProvider

        // Network
        let svc = MPCNetworkServiceImpl(identityProvider: identityProvider)
        let coord = PeerSessionCoordinator(networkService: svc, storage: baseStorage)
        let commonCoordinator = CommonChatCoordinator(networkService: svc, peerCoordinator: coord, chatHistoryStorage: chatHistoryStorage)
        self.networkService = svc
        self.coordinator = coord
        
        // Nearby Users
        self.nearbyUserViewModel = NearbyUserViewModel(coordinator: coord)
        self.commonChatViewModel = CommonChatViewModel(coordinator: commonCoordinator, networkSevice: svc)

        // Chats
        self.chatsRootViewModel = ChatsRootViewModel(
            chatListViewModel: ChatsListViewModel(
                coordinator: coord,
                storage: baseStorage
            ),
            chatScreenViewModel: ChatPreviewFixtures.newChat,
            nearbyUserViewModel: nearbyUserViewModel,
            coordinator: coord
        )
        self.chatsRootView = ChatsRootView (
            viewModel: chatsRootViewModel,
            router: router.chatsRouter,
            appRouter: router
        )

        // Common Chat
        self.commonChatRootView = CommonChatRootView(viewModel: commonChatViewModel, appRouter: router)
        
        // Settings
        self.settingsViewModel = SettingsViewModel(
            identityProvider: identityProvider,
            storage: baseStorage,
            onboardingState: self.onboardingState
        )
        self.settingsRootView = SettingsRootView(viewModel: settingsViewModel)
        
        // Onboarding
        self.welcomeScreenVM = WelcomeScreenVM(
            permissionManager: PermissionManager(notification: notificationService, permissionsStorage: permissionsStorage),
            identityProvider: identityProvider,
            onboardingState: self.onboardingState
        )
        self.welcomeScreenView = WelcomeScreenView(vm: welcomeScreenVM)
        
        self.appRootView = AppRootView(
            router: self.router,
            bluetoothStatusViewModel: bluetoothStatusViewModel,
            chatsRootView: chatsRootView,
            commonChatRootView: commonChatRootView,
            settingsRootView: settingsRootView,
            welcomeScreenVM: welcomeScreenVM,
            welcomeScreenView: welcomeScreenView,
            coordinator: coord,
            onboardingState: self.onboardingState
        )
        
        self.chatNotifications = ChatNotificationsController(
            peerCoordinator: coord,
            appRouter: router,
            notificationService: notificationService
        )
    }
}
