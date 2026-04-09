//
//  AppRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//

import SwiftUI

struct AppRootView: View {
    
    @Bindable var router: AppRouter
    let bluetoothStatusViewModel: BluetoothStatusViewModel
    let chatsRootView: ChatsRootView
    let commonChatRootView: CommonChatRootView
    let settingsRootView: SettingsRootView
    let welcomeScreenVM: WelcomeScreenVM
    let welcomeScreenView: WelcomeScreenView
    let coordinator: PeerSessionCoordinator
    let onboardingState: OnboardingState
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        if onboardingState.isOnboardingPassed {
            TabView(selection: $router.selectedTab) {
                chatsRootView
                    .tabItem {
                        Label("Чаты", systemImage: "message")
                    }
                    .tag(AppTab.chats)
                
                commonChatRootView
                    .tabItem {
                        Label("Общий чат", systemImage: "person.2")
                    }
                    .tag(AppTab.commonChat)
                
                settingsRootView
                    .tabItem {
                        Label("Настройки", systemImage: "gearshape")
                    }
                    .tag(AppTab.settings)
            }
            .tint(.p2PBlack)
            .fullScreenCover(isPresented: Binding(
                get: { bluetoothStatusViewModel.isBluetoothOff },
                set: { _ in }
            )) {
                NoBluetoothView()
            }
            .onAppear {
                coordinator.startIfNeeded()
            }
            .onChange(of: scenePhase) { // phase in
                switch scenePhase {
                case .active:
                    router.isAppActive = true
                    coordinator.appBecameActive()
                case .background:
                    router.isAppActive = false
                    router.activeDestination = nil
                    coordinator.appMovedToBackground()
                default: break
                }
            }
        } else {
            welcomeScreenView
        }
    }
}
