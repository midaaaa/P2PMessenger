//
//  ChatEmptyStateView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI
import Lottie

struct ChatEmptyStateView: View {
    let state: ChatEmptyState

    var body: some View {
        VStack(spacing: ChatUIConstants.EmptyState.verticalSpacing) {
            ZStack {
                Circle()
                    .fill(Color("P2PLightGray"))
                    .frame(
                        width: ChatUIConstants.EmptyState.outerCircleSize,
                        height: ChatUIConstants.EmptyState.outerCircleSize
                    )

                Circle()
                    .fill(Color("P2PBorder"))
                    .frame(
                        width: ChatUIConstants.EmptyState.innerCircleSize,
                        height: ChatUIConstants.EmptyState.innerCircleSize
                    )
                    .overlay {
                        Text(state.participant.avatarInitial)
                            .font(.system(size: ChatUIConstants.EmptyState.initialFontSize, weight: .medium))
                            .foregroundStyle(Color("P2PTextSecondary"))
                    }
            }

            Text(state.title)
                .font(.system(size: ChatUIConstants.EmptyState.titleFontSize, weight: .semibold))
                .foregroundStyle(Color("P2PTextPrimary"))

            Text(state.subtitle)
                .font(.system(size: ChatUIConstants.EmptyState.subtitleFontSize))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color("P2PTextTertiary"))

            LottieView(animation: .named("Bloo Waving"))
                .playing(loopMode: .loop)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .padding(.horizontal, ChatUIConstants.EmptyState.horizontalPadding)
    }
}
