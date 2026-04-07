//
//  CommonChatRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//
import SwiftUI

struct CommonChatRootView: View {
    @Bindable private var viewModel: CommonChatViewModel

    init(viewModel: CommonChatViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ChatScreenView(
            viewModel: viewModel.chatScreenViewModel,
            draftMessage: $viewModel.draftMessage,
            onSend: { text in
                viewModel.sendMeshMessage(text)
            }
        )
    }
}
