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
            try? await Task.sleep(for: .milliseconds(AppLaunchConstants.splashDelayMilliseconds))

            withAnimation(.easeOut(duration: AppLaunchConstants.splashFadeDuration)) {
                showsSplashScreen = false
            }
        }
    }
}

// MARK: - Брендированный splash-экран поверх системного launch screen

private struct LaunchSplashView: View {
    var body: some View {
        VStack(spacing: AppLaunchConstants.splashVerticalSpacing) {
            Image(AppLaunchConstants.logoAssetName)
                .resizable()
                .scaledToFit()
                .frame(
                    width: AppLaunchConstants.splashLogoSize,
                    height: AppLaunchConstants.splashLogoSize
                )

            Text(AppLaunchConstants.brandTitle)
                .font(
                    .system(
                        size: AppLaunchConstants.splashTitleFontSize,
                        weight: .regular,
                        design: .rounded
                    )
                )
                .foregroundStyle(AppLaunchConstants.splashTitleColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppLaunchConstants.splashBackgroundColor.ignoresSafeArea())
    }
}
