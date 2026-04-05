//
//  ChatsListView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 01.04.2026.
//

import SwiftUI


// MARK: - ChatsListView

struct ChatsListView: View {
    enum ChatsSegment: CaseIterable {
        case messages, requests

        var title: String {
            switch self {
            case .messages: String(localized: "chats_list_messages")
            case .requests: String(localized: "chats_list_requests")
            }
        }
    }
    
    private let viewModel: ChatsListViewModel
    @State private var selectedSegment: ChatsSegment
    private let plusButtonAction: () -> Void
    private let chatRowButtonAction: () -> Void
    
    init(viewModel: ChatsListViewModel,
         selectedSegment: ChatsSegment,
         plusButtonAction: @escaping () -> Void,
         chatRowButtonAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selectedSegment = selectedSegment
        self.plusButtonAction = plusButtonAction
        self.chatRowButtonAction = chatRowButtonAction
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
            segmentControlView
            chatListView
        }
        .background(Color("P2PLightGray"))
    }

    // MARK: Header

    private var headerView: some View {
        HStack {
            Text(String(localized: "chats_list_title"))
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color("P2PBlack"))

            Spacer()

            Button (action: plusButtonAction){
                Image(systemName: "plus")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Color("P2PDarkBlue"))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
    }

    // MARK: Segment Control

    private var segmentControlView: some View {
        HStack(spacing: 0) {
            ForEach(ChatsSegment.allCases, id: \.self) { segment in
                segmentTab(segment)
            }
        }
        .padding(4)
        .background(Color("P2PLightGray"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
    }

    private func badge(for segment: ChatsSegment) -> Int? {
        switch segment {
        case .messages: viewModel.unreadMessagesCount > 0 ? viewModel.unreadMessagesCount : nil
        case .requests: viewModel.requestsCount > 0 ? viewModel.requestsCount : nil
        }
    }

    private func segmentTab(_ segment: ChatsSegment) -> some View {
        let isActive = selectedSegment == segment

        return Button { selectedSegment = segment } label: {
            HStack(spacing: 4) {
                Text(segment.title)
                    .font(.system(size: 14, weight: isActive ? .medium : .regular))
                    .foregroundStyle(isActive ? Color("P2PDarkBlue") : Color("P2PDarkGray"))

                if let badge = badge(for: segment) {
                    Text("\(badge)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 16, height: 16)
                        .background(Color("P2PDarkBlue"))
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 37)
            .background {
                if isActive {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 1)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: Chat List

    private var currentChats: [ChatRowViewModel] {
        switch selectedSegment {
        case .messages: viewModel.messageChats
        case .requests: viewModel.requestChats
        }
    }

    private var chatListView: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(currentChats) { chat in
                    ChatRowView(chat: chat, onTap: chatRowButtonAction)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    ChatsListView(
        viewModel: ChatsListViewModel(
            chats: ChatListPreviewFixtures.stubChats),
        selectedSegment: .messages,
        plusButtonAction: {},
        chatRowButtonAction: {}
    )
}
#endif
