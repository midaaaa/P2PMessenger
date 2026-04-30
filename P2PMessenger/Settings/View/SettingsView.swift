//
//  SettingsView.swift
//  P2PMessenger
//
//  Created by Дмитрий Филимонов on 01.04.2026.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        List {
            Section {
                UserCard(username: $viewModel.username)
            } header: {
                Text("profileUpper")
                    .font(.footnote)
            }

            Section {
                StorageCard(formattedSize: viewModel.formattedSpaceTaken)
                Button {
                    viewModel.clearAllData()
                } label: {
                    DeleteCard()
                }
            } header: {
                Text("dataUpper")
                    .font(.footnote)
            }

            Section {

            }

            Section {} footer: {
                Text("appNameAndVersion")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    let baseStorage = AppKeyValueStorage(defaults: .standard)
    let profileStorage = AppProfileStorage(storage: baseStorage)
    let provider = LocalPeerIdentityProvider(profileStorage: profileStorage)
    let onboardingState = OnboardingState(storage: OnboardingStorage(storage: baseStorage))
    SettingsView(viewModel: SettingsViewModel(identityProvider: provider, storage: baseStorage, onboardingState: onboardingState))
}
