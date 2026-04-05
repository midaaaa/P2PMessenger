//
//  ChatScreenView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct ChatScreenView: View {
    private let viewModel: ChatScreenViewModel
    @Binding var draftMessage: String
    let onBack: () -> Void
    let onSend: (String) -> Void

    init(
        viewModel: ChatScreenViewModel,
        draftMessage: Binding<String>,
        onBack: @escaping () -> Void = {},
        onSend: @escaping (String) -> Void = { _ in }
    ) {
        self.viewModel = viewModel
        self._draftMessage = draftMessage
        self.onBack = onBack
        self.onSend = onSend
    }

    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(style: viewModel.headerStyle, onBack: onBack)

            Divider()
                .overlay(Color("P2PBorder"))

            contentSection

            ChatComposerView(
                placeholder: viewModel.composerPlaceholder,
                text: $draftMessage,
                onSend: onSend
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color("P2PBackground")
                .ignoresSafeArea()
        }
    }

    // MARK: - Контент: пустое состояние или история сообщений

    @ViewBuilder
    private var contentSection: some View {
        if viewModel.messages.isEmpty, let emptyState = viewModel.emptyState {
            VStack {
                Spacer(minLength: 0)
                ChatEmptyStateView(state: emptyState)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                VStack(spacing: ChatUIConstants.Screen.messageListVerticalSpacing) {
                    if let timelineTitle = viewModel.timelineTitle {
                        timelineBadge(title: timelineTitle)
                            .padding(.top, ChatUIConstants.Screen.timelineTopPadding)
                    }

                    ForEach(viewModel.messages) { message in
                        ChatMessageRowView(message: message)
                    }
                }
                .padding(.horizontal, ChatUIConstants.Screen.messageListHorizontalPadding)
                .padding(.vertical, ChatUIConstants.Screen.messageListVerticalPadding)
            }
            .scrollIndicators(.hidden)
        }
    }

    private func timelineBadge(title: String) -> some View {
        Text(title)
            .font(.system(size: ChatUIConstants.Screen.timelineFontSize))
            .foregroundStyle(Color("P2PTextSecondary"))
            .padding(.horizontal, ChatUIConstants.Screen.timelineHorizontalPadding)
            .padding(.vertical, ChatUIConstants.Screen.timelineVerticalPadding)
            .background(Color("P2PBorder"))
            .clipShape(Capsule())
    }
}

#Preview("Общий чат") {
    ChatScreenView(
        viewModel: ChatPreviewFixtures.publicChat,
        draftMessage: .constant("")
    )
}

#Preview("Новый чат") {
    ChatScreenView(
        viewModel: ChatPreviewFixtures.newChat,
        draftMessage: .constant("")
    )
}
