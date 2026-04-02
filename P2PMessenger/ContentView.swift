//
//  ContentView.swift
//  P2PMessenger
//
//  Created by Maksim on 31.03.2026.
//

import SwiftUI
import Observation

// MARK: - Точка входа приложения и контейнер сценариев

struct ContentView: View {
    @State private var viewModel: ChatScreenViewModel?

    init(configuration: ChatScreenConfiguration? = nil) {
        _viewModel = State(initialValue: configuration.map(ChatScreenViewModel.init))
    }

    var body: some View {
        if let viewModel {
            @Bindable var bindableViewModel = viewModel

            ChatScreenView(
                configuration: viewModel.configuration,
                draftMessage: $bindableViewModel.draftMessage,
                onSend: viewModel.sendMessage
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        } else {
            WelcomeScreenView()
        }
    }
}

#Preview("Онбординг") {
    ContentView()
}

#Preview("Общий чат") {
    ContentView(configuration: ChatPreviewFixtures.publicChat)
}

#Preview("Новый чат") {
    ContentView(configuration: ChatPreviewFixtures.newChat)
}
