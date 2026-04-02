//
//  ChatComposerView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct ChatComposerView: View {
    let placeholder: String
    @Binding var text: String
    let onSend: (String) -> Void

    var body: some View {
        HStack(spacing: ChatUIConstants.Composer.horizontalSpacing) {
            TextField(placeholder, text: $text)
                .font(.system(size: ChatUIConstants.Composer.textFontSize))
                .foregroundStyle(Color.p2pTextPrimary)
                .padding(.horizontal, ChatUIConstants.Composer.textHorizontalPadding)
                .frame(height: ChatUIConstants.Composer.textHeight)
                .background {
                    RoundedRectangle(cornerRadius: ChatUIConstants.Composer.textCornerRadius, style: .continuous)
                        .fill(Color.p2pBackground)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: ChatUIConstants.Composer.textCornerRadius, style: .continuous)
                        .strokeBorder(Color.p2pBorder, lineWidth: ChatUIConstants.Composer.textBorderWidth)
                }
                .textFieldStyle(.plain)
                .submitLabel(.send)
                .onSubmit(sendMessage)

            Button(action: sendMessage) {
                Image(systemName: "paperplane")
                    .font(.system(size: ChatUIConstants.Composer.sendIconSize, weight: .medium))
                    .foregroundStyle(Color.p2pTextTertiary)
                    .frame(
                        width: ChatUIConstants.Composer.sendButtonSize,
                        height: ChatUIConstants.Composer.sendButtonSize
                    )
                    .background(Color.p2pLightGray)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(trimmedText.isEmpty)
            .opacity(trimmedText.isEmpty ? ChatUIConstants.Composer.sendDisabledOpacity : 1)
        }
        .padding(.horizontal, ChatUIConstants.Composer.horizontalPadding)
        .padding(.top, ChatUIConstants.Composer.topPadding)
        .padding(.bottom, ChatUIConstants.Composer.bottomPadding)
        .background(Color.p2pSurface)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.p2pBorder)
                .frame(height: 1)
        }
    }

    // MARK: - Отправка сообщения

    private var trimmedText: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func sendMessage() {
        guard !trimmedText.isEmpty else { return }
        onSend(trimmedText)
        text = ""
    }
}
