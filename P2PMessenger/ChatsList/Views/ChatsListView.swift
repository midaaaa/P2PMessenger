//
//  ChatsListView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 01.04.2026.
//

import SwiftUI

// MARK: - Supporting Types

private enum ChatsSegment: CaseIterable {
    case messages, requests

    var title: String {
        switch self {
        case .messages: "Сообщения"
        case .requests: "Запросы"
        }
    }
}

// MARK: - ChatsListView

struct ChatsListView: View {
    @State private var viewModel = ChatsListViewModel()
    @State private var selectedSegment: ChatsSegment = .messages

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
            Text("Список чатов")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color("P2PBlack"))

            Spacer()

            Button {} label: {
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

    private var currentChats: [ChatRowModel] {
        switch selectedSegment {
        case .messages: viewModel.messageChats
        case .requests: viewModel.requestChats
        }
    }

    private var chatListView: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(currentChats) { chat in
                    chatRow(chat)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }

    private func chatRow(_ chat: ChatRowModel) -> some View {
        Button {} label: {
            HStack(spacing: 0) {
                avatarView(initial: String(chat.name.prefix(1)), isOnline: chat.isOnline)
                    .padding(.leading, 14)

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(chat.name)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color("P2PDarkBlue"))
                            .lineLimit(1)

                        Spacer()

                        Text(chat.timeOfLastMessage.shortTimeString)
                            .font(.system(size: 12))
                            .foregroundStyle(Color("P2PDarkGray"))
                    }

                    HStack {
                        Text(chat.lastMessage)
                            .font(.system(size: 13))
                            .foregroundStyle(Color("P2PDarkGray"))
                            .lineLimit(1)

                        Spacer()

                        if chat.unreadCount > 0 {
                            Text("\(chat.unreadCount)")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 20, height: 20)
                                .background(Color("P2PDarkBlue"))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.leading, 12)
                .padding(.trailing, 14)
            }
            .frame(height: 78)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("P2PLightGray"), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func avatarView(initial: String, isOnline: Bool) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Text(initial)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color("P2PDarkGray"))
                .frame(width: 48, height: 48)
                .background(Color("P2PLightGray"))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("P2PLightGray"), lineWidth: 1))

            Circle()
                .fill(isOnline ? Color("P2PGreen") : Color("P2PDarkGray"))
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(.white, lineWidth: 2))
        }
    }
}

// MARK: - Preview

#Preview {
    ChatsListView()
}
