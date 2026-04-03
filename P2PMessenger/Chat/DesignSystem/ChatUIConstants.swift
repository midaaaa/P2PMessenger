//
//  ChatUIConstants.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

enum ChatUIConstants {
    enum Header {
        static let horizontalPadding: CGFloat = 12
        static let directHeight: CGFloat = 64
        static let groupHeight: CGFloat = 56
        static let directAvatarSize: CGFloat = 36
        static let directInfoSpacing: CGFloat = 2
        static let directTitleSize: CGFloat = 15
        static let directSubtitleSize: CGFloat = 12
        static let groupTitleSize: CGFloat = 17
        static let groupSubtitleSize: CGFloat = 11
        static let backControlSpacing: CGFloat = 4
        static let backIconSize: CGFloat = 14
        static let backTextSize: CGFloat = 15
    }

    enum Screen {
        static let messageListVerticalSpacing: CGFloat = 12
        static let messageListHorizontalPadding: CGFloat = 16
        static let messageListVerticalPadding: CGFloat = 12
        static let timelineTopPadding: CGFloat = 8
        static let timelineFontSize: CGFloat = 11
        static let timelineHorizontalPadding: CGFloat = 12
        static let timelineVerticalPadding: CGFloat = 4
    }

    enum MessageRow {
        static let rowSpacing: CGFloat = 8
        static let participantNameSpacing: CGFloat = 4
        static let participantNameSize: CGFloat = 11
        static let messageAvatarSize: CGFloat = 36
        static let bubbleMaxWidth: CGFloat = 246
        static let bubbleTextSize: CGFloat = 15
        static let bubbleTimeSize: CGFloat = 11
        static let bubbleTextTimeSpacing: CGFloat = 6
        static let bubbleHorizontalPadding: CGFloat = 16
        static let bubbleVerticalPadding: CGFloat = 10
        static let bubbleRadiusLarge: CGFloat = 16
        static let bubbleRadiusSmall: CGFloat = 6
        static let bubbleBorderWidth: CGFloat = 1
    }

    enum Composer {
        static let horizontalSpacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 12
        static let topPadding: CGFloat = 13
        static let bottomPadding: CGFloat = 12
        static let textHorizontalPadding: CGFloat = 16
        static let textHeight: CGFloat = 44.5
        static let textCornerRadius: CGFloat = 16
        static let textBorderWidth: CGFloat = 1
        static let textFontSize: CGFloat = 15
        static let sendIconSize: CGFloat = 16
        static let sendButtonSize: CGFloat = 40
        static let sendDisabledOpacity: CGFloat = 0.6
    }

    enum EmptyState {
        static let verticalSpacing: CGFloat = 10
        static let outerCircleSize: CGFloat = 64
        static let innerCircleSize: CGFloat = 56
        static let initialFontSize: CGFloat = 17
        static let titleFontSize: CGFloat = 17
        static let subtitleFontSize: CGFloat = 13
        static let horizontalPadding: CGFloat = 24
    }
}
