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
                Toggle(isOn: $viewModel.visibilityToggle) {
                    TextCard(label: String(localized: "enableToFindMe"),
                             text: String(localized: "observableByOthers"))
                }
                .tint(Color("P2PDarkBlue"))
                Toggle(isOn: $viewModel.requestToggle) {
                    TextCard(label: String(localized: "enableRequestsToChat"),
                             text: String(localized: "acceptNewRequests"))
                }
                .tint(Color("P2PDarkBlue"))
            } header: {
                Text("privacyUpper")
                    .font(.footnote)
            }

            Section {
                Toggle(isOn: $viewModel.networkToggle) {
                    TextCard(label: String(localized: "online"),
                             text: String(localized: "observableInP2Pnetwork"))
                }
                .tint(Color("P2PDarkBlue"))
            } header: {
                Text("networkUpper")
                    .font(.footnote)
            }

            Section {
                StorageCard(size: viewModel.spaceTaken, progress: $viewModel.progress)
            } header: {
                Text("dataUpper")
                    .font(.footnote)
            }

            Section {
                Button {
                    viewModel.clearAllData()
                } label: {
                    DeleteCard()
                }
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
