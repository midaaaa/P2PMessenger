//
//  ChatHeaderView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI
import Foundation

struct ChatHeaderView: View {
    let style: ChatHeaderStyle
    let onBack: () -> Void

    init(style: ChatHeaderStyle, onBack: @escaping () -> Void = {}) {
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        switch style {
        case let .direct(participant, subtitle):
            directHeader(participant: participant, subtitle: subtitle)
        case let .group(title, subtitle):
            groupHeader(title: title, subtitle: subtitle)
        }
    }

    // MARK: - Варианты шапки: личный и общий чат

    private func directHeader(participant: ChatParticipant, subtitle: String) -> some View {
        HStack(spacing: ChatUIConstants.Header.horizontalPadding) {
            backButton

            AvatarView(
                initial: participant.avatarInitial,
                isOnline: participant.isOnline,
                size: ChatUIConstants.Header.directAvatarSize
            )

            VStack(alignment: .leading, spacing: ChatUIConstants.Header.directInfoSpacing) {
                Text(participant.name)
                    .font(.system(size: ChatUIConstants.Header.directTitleSize, weight: .semibold))
                    .foregroundStyle(Color.p2pTextPrimary)

                Text(subtitle)
                    .font(.system(size: ChatUIConstants.Header.directSubtitleSize))
                    .foregroundStyle(Color.p2pTextTertiary)
            }

            Spacer()
        }
        .padding(.horizontal, ChatUIConstants.Header.horizontalPadding)
        .frame(height: ChatUIConstants.Header.directHeight)
        .background(Color.p2pSurface)
    }

    private func groupHeader(title: String, subtitle: String) -> some View {
        ZStack {
            HStack {
                backButton
                Spacer()
            }

            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: ChatUIConstants.Header.groupTitleSize, weight: .semibold))
                    .foregroundStyle(Color.p2pTextPrimary)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.system(size: ChatUIConstants.Header.groupSubtitleSize))
                    .foregroundStyle(Color.p2pTextTertiary)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, ChatUIConstants.Header.horizontalPadding)
        .frame(height: ChatUIConstants.Header.groupHeight)
        .background(Color.p2pSurface)
    }

    // MARK: - Навигационные элементы

    private var backButton: some View {
        Button(action: onBack) {
            HStack(spacing: ChatUIConstants.Header.backControlSpacing) {
                Image(systemName: "chevron.left")
                    .font(.system(size: ChatUIConstants.Header.backIconSize, weight: .regular))
                Text(String(localized: "Назад"))
                    .font(.system(size: ChatUIConstants.Header.backTextSize, weight: .regular))
            }
            .foregroundStyle(Color.p2pTextSecondary)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
