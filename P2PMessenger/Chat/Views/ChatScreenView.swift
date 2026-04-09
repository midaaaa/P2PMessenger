//
//  ChatScreenView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct ChatScreenView<ViewModel: ChatScreenViewModelProtocol & Observable>: View {
    private let viewModel: ViewModel
    @Binding var draftMessage: String
    let onBack: () -> Void
    let onSend: (String) -> Bool
    let alignsMessagesToBottom: Bool
    let enablesAutoScrollToBottom: Bool
    @FocusState var isKeyboardFocused: Bool

    init(
        viewModel: ViewModel,
        draftMessage: Binding<String>,
        onBack: @escaping () -> Void = {},
        onSend: @escaping (String) -> Bool = { _ in false },
        alignsMessagesToBottom: Bool = false,
        enablesAutoScrollToBottom: Bool = false
    ) {
        self.viewModel = viewModel
        self._draftMessage = draftMessage
        self.onBack = onBack
        self.onSend = onSend
        self.alignsMessagesToBottom = alignsMessagesToBottom
        self.enablesAutoScrollToBottom = enablesAutoScrollToBottom
    }

    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(style: viewModel.headerStyle, onBack: onBack)
                .onTapGesture {isKeyboardFocused = false}

            Divider()
                .overlay(Color("P2PBorder"))

            contentSection
                .scrollDismissesKeyboard(.interactively)
                .onTapGesture {isKeyboardFocused = false}

            ChatComposerView(
                text: $draftMessage,
                onSend: onSend,
                placeholder: chatTypeText,
                isKeyboardFocused: _isKeyboardFocused
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color("P2PBackground")
                .ignoresSafeArea()
                .onTapGesture {isKeyboardFocused = false}
        }
    }
    
    private var chatTypeText: String {
        switch viewModel.headerStyle {
        case .direct:
            return String(localized: "message")
        case .group:
            return String(localized: "messageEveryone")
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
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: ChatUIConstants.Screen.messageListVerticalSpacing) {
                        if let timelineTitle = viewModel.timelineTitle {
                            timelineBadge(title: timelineTitle)
                                .padding(.top, ChatUIConstants.Screen.timelineTopPadding)
                        }

                        ForEach(viewModel.messages) { message in
                            ChatMessageRowView(message: message)
                        }

                        Color.clear
                            .frame(height: 1)
                            .id("chat-bottom-anchor")
                    }
                    .padding(.horizontal, ChatUIConstants.Screen.messageListHorizontalPadding)
                    .padding(.vertical, ChatUIConstants.Screen.messageListVerticalPadding)
                }
                .defaultScrollAnchor(.bottom)
                .task {
                    guard enablesAutoScrollToBottom else { return }
                    await Task.yield()
                    proxy.scrollTo("chat-bottom-anchor", anchor: .bottom)
                }
                .task(id: viewModel.messages.count) {
                    guard enablesAutoScrollToBottom else { return }
                    await Task.yield()
                    withAnimation {
                        proxy.scrollTo("chat-bottom-anchor", anchor: .bottom)
                    }
                }
            }
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
#Preview("Новый чат") {
    let storage = AppProfileStorage(storage: AppKeyValueStorage(defaults: .standard))
    let provider = LocalPeerIdentityProvider(profileStorage: storage)
    ChatScreenView(
        viewModel: ChatScreenViewModel(
            networkService: MPCNetworkServiceImpl(identityProvider: provider),
            headerStyle: .direct(
                participant: ChatParticipant(
                    name: "Глеб",
                    isOnline: true
                ),
                subtitle: "Новый чат"
            ),
            emptyState: ChatEmptyState(
                participant: ChatParticipant(
                    name: "Глеб",
                    isOnline: true
                ),
                title: "Глеб",
                subtitle: "Напишите первое сообщение.\nСобеседник получит запрос на чат."
            )
        ),
        draftMessage: .constant("")
    )
}


#Preview("Новый чат hardcode") {
    ChatScreenView(
        viewModel: ChatPreviewFixtures.newChat,
        draftMessage: .constant("")
    )
}

#Preview("Общий чат hardcode") {
    ChatScreenView(
        viewModel: ChatPreviewFixtures.publicChat,
        draftMessage: .constant("")
    )
}

@MainActor
extension ChatPreviewFixtures {
    fileprivate static let publicChat: ChatScreenViewModel = {
        let vasya = ChatParticipant(name: "Вася", isOnline: true)
        let masha = ChatParticipant(name: "Маша", isOnline: true)
        let gleb = ChatParticipant(name: "Глеб", isOnline: true)

        return ChatScreenViewModel.groupChat(
            title: "Общий чат",
            participantsSubtitle: "5 участников",
            messages: [
                ChatMessage(
                    sender: .incoming(vasya),
                    text: "Всем привет! Кто сегодня в парке?",
                    time: "11:02"
                ),
                ChatMessage(
                    sender: .incoming(masha),
                    text: "Я буду после 15:00",
                    time: "11:04"
                ),
                ChatMessage(
                    sender: .outgoing,
                    text: "Отлично, тогда встречаемся у фонтана 🙂",
                    time: "11:05"
                ),
                ChatMessage(
                    sender: .incoming(gleb),
                    text: "Я тоже подойду! Возьмите термос",
                    time: "11:07"
                ),
                ChatMessage(
                    sender: .incoming(vasya),
                    text: "Хорошая идея 👍",
                    time: "11:09"
                )
            ],
            timelineTitle: "Сегодня · Общий чат"
        )
    }()
}
