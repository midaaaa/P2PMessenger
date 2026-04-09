//
//  ChatMessageRowView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct ChatMessageRowView: View {
    let message: ChatMessage

    var body: some View {
        if message.isOutgoing {
            outgoingMessageRow
        } else if let participant = message.incomingParticipant {
            incomingMessageRow(participant: participant)
        } else {
            EmptyView()
        }
    }

    // MARK: - Разметка входящего и исходящего сообщения

    private var outgoingMessageRow: some View {
        HStack {
            Spacer(minLength: 0)

            ChatBubbleView(
                text: message.text,
                time: message.time,
                style: .outgoing
            )
            .frame(maxWidth: ChatUIConstants.MessageRow.bubbleMaxWidth, alignment: .trailing)
        }
    }

    private func incomingMessageRow(participant: ChatParticipant) -> some View {
        HStack(alignment: .bottom, spacing: ChatUIConstants.MessageRow.rowSpacing) {
            AvatarView(
                initial: participant.avatarInitial,
                isOnline: participant.isOnline,
                size: ChatUIConstants.MessageRow.messageAvatarSize
            )

            VStack(alignment: .leading, spacing: ChatUIConstants.MessageRow.participantNameSpacing) {
                Text(participant.name)
                    .font(.system(size: ChatUIConstants.MessageRow.participantNameSize))
                    .foregroundStyle(Color("P2PTextTertiary"))

                ChatBubbleView(
                    text: message.text,
                    time: message.time,
                    style: .incoming
                )
                .frame(maxWidth: ChatUIConstants.MessageRow.bubbleMaxWidth, alignment: .leading)
            }

            Spacer(minLength: 0)
        }
    }
}

// MARK: - Бабл сообщения и его стиль

private struct ChatBubbleView: View {
    enum Style: Equatable {
        case incoming
        case outgoing
    }

    let text: String
    let time: String
    let style: Style

    var body: some View {
        VStack(alignment: .leading, spacing: ChatUIConstants.MessageRow.bubbleTextTimeSpacing) {
            Text(text)
                .font(.system(size: ChatUIConstants.MessageRow.bubbleTextSize))
                .foregroundStyle(textColor)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Spacer(minLength: 0)
                Text(time)
                    .font(.system(size: ChatUIConstants.MessageRow.bubbleTimeSize))
                    .foregroundStyle(timeColor)
            }
        }
        .padding(.horizontal, ChatUIConstants.MessageRow.bubbleHorizontalPadding)
        .padding(.vertical, ChatUIConstants.MessageRow.bubbleVerticalPadding)
        .background(backgroundView)
        .overlay {
            if style == .incoming {
                incomingBorder
            }
        }
    }

    private var backgroundView: some View {
        bubbleShape
            .fill(style == .outgoing ? Color("P2PDarkBlue") : Color("P2PSurface"))
    }

    private var incomingBorder: some View {
        bubbleShape
            .stroke(Color("P2PBorder"), lineWidth: ChatUIConstants.MessageRow.bubbleBorderWidth)
    }

    private var bubbleShape: UnevenRoundedRectangle {
        switch style {
        case .incoming:
            return UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: ChatUIConstants.MessageRow.bubbleRadiusLarge,
                    bottomLeading: ChatUIConstants.MessageRow.bubbleRadiusSmall,
                    bottomTrailing: ChatUIConstants.MessageRow.bubbleRadiusLarge,
                    topTrailing: ChatUIConstants.MessageRow.bubbleRadiusLarge
                ),
                style: .continuous
            )
        case .outgoing:
            return UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: ChatUIConstants.MessageRow.bubbleRadiusLarge,
                    bottomLeading: ChatUIConstants.MessageRow.bubbleRadiusLarge,
                    bottomTrailing: ChatUIConstants.MessageRow.bubbleRadiusSmall,
                    topTrailing: ChatUIConstants.MessageRow.bubbleRadiusLarge
                ),
                style: .continuous
            )
        }
    }

    private var textColor: Color {
        style == .outgoing ? .p2PSurface : Color("P2PTextPrimary")
    }

    private var timeColor: Color {
        style == .outgoing ? Color("P2PTextTertiary").opacity(0.9) : Color("P2PTextTertiary")
    }
}
