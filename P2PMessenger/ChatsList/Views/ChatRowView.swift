//
//  ChatRowView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 03.04.2026.
//

import SwiftUI

struct ChatRowView: View {
    let content: ChatRowContent
    let onUserButtonTap : () -> Void

    var body: some View {
        Button (action: onUserButtonTap) {
            HStack(spacing: 0) {
                avatarView
                    .padding(.leading, 14)
                contentView
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

    private var avatarInitial: String {
        switch content {
        case .chats(let chat): String(chat.name.prefix(1))
        case .nearbyusrs(let user): String(user.name.prefix(1))
        }
    }

    private var isOnline: Bool {
        switch content {
        case .chats(let chat): chat.isOnline
        case .nearbyusrs(let user): user.isOnline
        }
    }

    private var avatarView: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(avatarInitial)
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

    @ViewBuilder
    private var contentView: some View {
        switch content {
        case .chats(let chat):
            SavedChatRowContent(chat: chat)
        case .nearbyusrs(let user):
            NearbyUserRowContent(user: user)
        }
    }
}

// MARK: - Saved Chat Content

private struct SavedChatRowContent: View {
    let chat: ChatRowViewModel

    var body: some View {
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
    }
}

// MARK: - Nearby User Content

private struct NearbyUserRowContent: View {
    let user: NearbyUserModel

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Text(user.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color("P2PDarkBlue"))
                    .lineLimit(1)

                if user.isOnline {
                    Text(String(localized: "nearby_user_online_status"))
                        .font(.system(size: 11))
                        .foregroundStyle(Color("P2PDarkGray"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color("P2PLightGray"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            Spacer()

            HStack(spacing: 8) {
                Image("bluetoothIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(Color("P2PDarkGray"))

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(Color("P2PDarkGray"))
            }
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Saved Chat") {
    ChatRowView(content: .chats(ChatRowViewModel(
        id: UUID(),
        name: "Вася",
        timeOfLastMessage: Date().addingTimeInterval(-3600),
        lastMessage: "Окей, до встречи!",
        unreadCount: 2,
        isOnline: true,
        status: .active)
    ),
    onUserButtonTap: {})
    .padding()
}

#Preview("Nearby User") {
    ChatRowView(content: .nearbyusrs(NearbyUserModel(
        id: UUID(),
        name: "Глеб",
        isOnline: true)
    ),
    onUserButtonTap: {})
    .padding()
}
#endif
