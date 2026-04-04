//
//  CommonChatRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//
import SwiftUI

struct CommonChatRootView: View {
    var body: some View {
        ChatScreenView(
            configuration: ChatPreviewFixtures.publicChat,
            draftMessage: .constant("")
        )
    }
}
