//
//  ChatEmptyStateView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct ChatEmptyStateView: View {
    let state: ChatEmptyState

    var body: some View {
        VStack(spacing: ChatUIConstants.EmptyState.verticalSpacing) {
            ZStack {
                Circle()
                    .fill(Color.p2pLightGray)
                    .frame(
                        width: ChatUIConstants.EmptyState.outerCircleSize,
                        height: ChatUIConstants.EmptyState.outerCircleSize
                    )

                Circle()
                    .fill(Color.p2pBorder)
                    .frame(
                        width: ChatUIConstants.EmptyState.innerCircleSize,
                        height: ChatUIConstants.EmptyState.innerCircleSize
                    )
                    .overlay {
                        Text(state.participant.avatarInitial)
                            .font(.system(size: ChatUIConstants.EmptyState.initialFontSize, weight: .medium))
                            .foregroundStyle(Color.p2pTextSecondary)
                    }
            }

            Text(state.title)
                .font(.system(size: ChatUIConstants.EmptyState.titleFontSize, weight: .semibold))
                .foregroundStyle(Color.p2pTextPrimary)

            Text(state.subtitle)
                .font(.system(size: ChatUIConstants.EmptyState.subtitleFontSize))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.p2pTextTertiary)
        }
        .padding(.horizontal, ChatUIConstants.EmptyState.horizontalPadding)
    }
}
