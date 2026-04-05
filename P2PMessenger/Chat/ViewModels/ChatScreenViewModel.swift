//
//  ChatScreenViewModel.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 04.04.2026.
//


struct ChatScreenViewModel: Hashable {
    let headerStyle: ChatHeaderStyle
    let timelineTitle: String?
    let messages: [ChatMessage]
    let emptyState: ChatEmptyState?
    let composerPlaceholder: String

    init(
        headerStyle: ChatHeaderStyle,
        timelineTitle: String? = nil,
        messages: [ChatMessage] = [],
        emptyState: ChatEmptyState? = nil,
        composerPlaceholder: String
    ) {
        self.headerStyle = headerStyle
        self.timelineTitle = timelineTitle
        self.messages = messages
        self.emptyState = emptyState
        self.composerPlaceholder = composerPlaceholder
    }
}