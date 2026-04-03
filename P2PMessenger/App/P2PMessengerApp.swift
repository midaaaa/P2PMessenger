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
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
