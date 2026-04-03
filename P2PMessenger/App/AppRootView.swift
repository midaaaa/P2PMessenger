//
//  AppRouter.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//

import SwiftUI

struct AppRootView: View {
    @State private var appRouter = AppRouter()
    @StateObject private var bluetoothVM = BluetoothStatusViewModel()
    
    var body: some View {
        
            TabView(selection: $appRouter.selectedTab) {
                ChatsRootView(router: appRouter.chatsRouter)
                    .tabItem {
                        Label("Чаты", systemImage: "message")
                    }
                    .tag(AppTab.chats)
                
                CommonChatRootView()
                    .tabItem {
                        Label("Общий чат", systemImage: "person.2")
                    }
                    .tag(AppTab.commonChat)
                
                SettingsRootView()
                    .tabItem {
                        Label("Настройки", systemImage: "gearshape")
                    }
                    .tag(AppTab.settings)
            }
            .tint(.p2PBlack)
        
        .fullScreenCover(isPresented: $bluetoothVM.isBluetoothOff) {
            NoBluetoothView()
        }
        
    }
        func openBluetoothSettings() {
            guard let settingsURL = URL(string: "App-Prefs:root=Bluetooth") else {
                return // UIApplication.openSettingsURLString
            }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
            
        }
    
}
#if DEBUG
#Preview {
    AppRootView()
}
#endif
