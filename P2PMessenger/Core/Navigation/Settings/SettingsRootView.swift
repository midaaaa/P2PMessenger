//
//  SettingsRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//
import SwiftUI

struct SettingsRootView: View {
    //@Bindable var router: SettingsRouter

    var body: some View {
        NavigationStack() {
            SettingsView()
//                .navigationDestination(for: SettingsRoute.self) { route in
//                    switch route {
//                    case .editProfile:
//                        EditProfileView()
//
//                    case .notifications:
//                        NotificationsSettingsView()
//
//                    case .privacy:
//                        PrivacySettingsView()
//                    }
//                }
        }
    }
}
