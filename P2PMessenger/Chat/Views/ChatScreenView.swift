//
//  ChatScreenView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct ChatScreenView: View {
    let configuration: ChatScreenConfiguration
    @Binding var draftMessage: String
    let onBack: () -> Void
    let onSend: (String) -> Void

    init(
        configuration: ChatScreenConfiguration,
        draftMessage: Binding<String>,
        onBack: @escaping () -> Void = {},
        onSend: @escaping (String) -> Void = { _ in }
    ) {
        self.configuration = configuration
        self._draftMessage = draftMessage
        self.onBack = onBack
        self.onSend = onSend
    }

    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(style: configuration.headerStyle, onBack: onBack)

            Divider()
                .overlay(Color.p2pBorder)

            contentSection

            ChatComposerView(
                placeholder: configuration.composerPlaceholder,
                text: $draftMessage,
                onSend: onSend
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color.p2pBackground
                .ignoresSafeArea()
        }
    }

    // MARK: - Контент: пустое состояние или история сообщений

    @ViewBuilder
    private var contentSection: some View {
        if configuration.messages.isEmpty, let emptyState = configuration.emptyState {
            VStack {
                Spacer(minLength: 0)
                ChatEmptyStateView(state: emptyState)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                VStack(spacing: ChatUIConstants.Screen.messageListVerticalSpacing) {
                    if let timelineTitle = configuration.timelineTitle {
                        timelineBadge(title: timelineTitle)
                            .padding(.top, ChatUIConstants.Screen.timelineTopPadding)
                    }

                    ForEach(configuration.messages) { message in
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
            .foregroundStyle(Color.p2pTextSecondary)
            .padding(.horizontal, ChatUIConstants.Screen.timelineHorizontalPadding)
            .padding(.vertical, ChatUIConstants.Screen.timelineVerticalPadding)
            .background(Color.p2pBorder)
            .clipShape(Capsule())
    }
}

#Preview("Общий чат") {
    ChatScreenView(
        configuration: ChatPreviewFixtures.publicChat,
        draftMessage: .constant("")
    )
}

#Preview("Новый чат") {
    ChatScreenView(
        configuration: ChatPreviewFixtures.newChat,
        draftMessage: .constant("")
    )
}
