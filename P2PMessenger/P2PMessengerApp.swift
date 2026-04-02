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
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}

// MARK: - Корневой контейнер запуска приложения

private struct AppRootView: View {
    @State private var showsSplashScreen = true

    var body: some View {
        ZStack {
            ContentView()
                .opacity(showsSplashScreen ? 0 : 1)

            if showsSplashScreen {
                LaunchSplashView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(650))

            withAnimation(.easeOut(duration: 0.2)) {
                showsSplashScreen = false
            }
        }
    }
}

// MARK: - Брендированный splash-экран поверх системного launch screen

private struct LaunchSplashView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("LaunchLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)

            Text("P2P Messenger")
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .foregroundStyle(Color.p2pTextPrimary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.p2pBackground.ignoresSafeArea())
    }
}
