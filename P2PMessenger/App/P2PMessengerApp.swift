//
//  P2PMessengerApp.swift
//  P2PMessenger
//
//  Created by Maksim on 31.03.2026.
//

import SwiftUI
import SwiftData

@main
struct P2PMessengerApp: App {
    
    init() {
        _ = BluetoothMonitor.shared
    }
    @State private var container = DependencyContainer()
    
    @UIApplicationDelegateAdaptor(AppNotificationDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(container)
                .onAppear {
                    appDelegate.container = container
                }
        }
    }
}
