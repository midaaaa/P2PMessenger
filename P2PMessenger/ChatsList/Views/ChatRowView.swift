//
//  ChatRowView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 03.04.2026.
//

import SwiftUI

struct ChatRowView: View {
    let chat: ChatRowViewModel
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                avatarView
                    .padding(.leading, 14)
                chatContent
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
    
    private var statusColor: Color {
        chat.isOnline ? Color("P2PGreen") : Color("P2PDarkGray")
    }

    private var avatarView: some View {
        UserAvatarView(initial: String(chat.name.prefix(1)), statusColor: statusColor)
    }

    private var chatContent: some View {
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

// MARK: - Preview

#if DEBUG
#Preview {
    ChatRowView(
        chat: ChatRowViewModel(
            id: UUID(),
            name: "Вася",
            timeOfLastMessage: Date().addingTimeInterval(-3600),
            lastMessage: "Окей, до встречи!",
            unreadCount: 2,
            isOnline: true,
            status: .active
        ),
        onTap: {}
    )
    .padding()
}
#endif
