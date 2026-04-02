//
//  ChatsListView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 01.04.2026.
//

import SwiftUI

// MARK: - ChatsListView

struct ChatsListView: View {
    @State private var selectedTab = 0

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
            segmentTab(title: "Сообщения", badge: nil, index: 0)
            segmentTab(title: "Запросы", badge: 1, index: 1)
        }
        .padding(4)
        .background(Color("P2PLightGray"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
    }

    private func segmentTab(title: String, badge: Int?, index: Int) -> some View {
        let isActive = selectedTab == index

        return Button { selectedTab = index } label: {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: isActive ? .medium : .regular))
                    .foregroundStyle(isActive ? Color("P2PDarkBlue") : Color("P2PDarkGray"))

                if let badge {
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

    private var chatListView: some View {
        ScrollView {
            VStack(spacing: 8) {
                chatRow(name: "Вася", time: "14:32", lastMessage: "Окей, до встречи!", unread: 2, isOnline: true)
                chatRow(name: "Маша", time: "12:15", lastMessage: "Пришли ссылку позже", unread: 0, isOnline: false)
                chatRow(name: "Коля", time: "11:00", lastMessage: "Всё понял, спасибо!", unread: 0, isOnline: true)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }

    private func chatRow(
        name: String,
        time: String,
        lastMessage: String,
        unread: Int,
        isOnline: Bool
    ) -> some View {
        Button {} label: {
            HStack(spacing: 0) {
                avatarView(initial: String(name.prefix(1)), isOnline: isOnline)
                    .padding(.leading, 14)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(name)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color("P2PDarkBlue"))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(time)
                            .font(.system(size: 12))
                            .foregroundStyle(Color("P2PDarkGray"))
                    }
                    
                    HStack {
                        Text(lastMessage)
                            .font(.system(size: 13))
                            .foregroundStyle(Color("P2PDarkGray"))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if unread > 0 {
                            Text("\(unread)")
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
