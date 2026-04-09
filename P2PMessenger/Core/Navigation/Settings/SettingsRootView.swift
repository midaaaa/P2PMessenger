//
//  SettingsRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//
import SwiftUI

struct SettingsRootView: View {
    let viewModel: SettingsViewModel

    var body: some View {
        SettingsView(viewModel: viewModel)
            .navigationTitle("Settings")
            .onAppear {
                viewModel.syncDisplayName()
            }
            .task {
                await viewModel.loadStorageSize()
            }
    }
}
