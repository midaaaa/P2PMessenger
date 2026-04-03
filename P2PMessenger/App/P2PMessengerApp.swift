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
    
    @StateObject private var container = DependencyContainer()
    
    @UIApplicationDelegateAdaptor(AppNotificationDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(container)
                .onAppear {
                    appDelegate.container = container
                }
        }
    }
}
