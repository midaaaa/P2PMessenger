//
//  CommonChatRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//
import SwiftUI

struct CommonChatRootView: View {
    @Bindable private var viewModel: CommonChatViewModel
    @Bindable private var appRouter: AppRouter

    init(viewModel: CommonChatViewModel, appRouter: AppRouter) {
        self.viewModel = viewModel
        self.appRouter = appRouter
    }

    var body: some View {
        ChatScreenView(
            viewModel: viewModel.chatScreenViewModel,
            draftMessage: $viewModel.draftMessage,
            onSend: { text in
                viewModel.sendMeshMessage(text)
            },
            alignsMessagesToBottom: true,
            enablesAutoScrollToBottom: true
        )
        .onAppear {
            appRouter.activeDestination = .common
        }
        .onDisappear {
            if appRouter.activeDestination == .common {
                appRouter.activeDestination = nil
            }
        }
    }
}
