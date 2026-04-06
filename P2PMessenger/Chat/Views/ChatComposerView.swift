//
//  ChatComposerView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct ChatComposerView: View {
    @Binding var text: String
    let onSend: (String) -> Void
    var placeholder: String

    var body: some View {
        HStack(spacing: ChatUIConstants.Composer.horizontalSpacing) {
            TextField(placeholder, text: $text)
                .font(.system(size: ChatUIConstants.Composer.textFontSize))
                .foregroundStyle(Color("P2PTextPrimary"))
                .padding(.horizontal, ChatUIConstants.Composer.textHorizontalPadding)
                .frame(height: ChatUIConstants.Composer.textHeight)
                .background {
                    RoundedRectangle(cornerRadius: ChatUIConstants.Composer.textCornerRadius, style: .continuous)
                        .fill(Color("P2PBackground"))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: ChatUIConstants.Composer.textCornerRadius, style: .continuous)
                        .strokeBorder(Color("P2PBorder"), lineWidth: ChatUIConstants.Composer.textBorderWidth)
                }
                .textFieldStyle(.plain)
                .submitLabel(.send)
                .onSubmit(sendMessage)

            Button(action: sendMessage) {
                Image(systemName: "paperplane")
                    .font(.system(size: ChatUIConstants.Composer.sendIconSize, weight: .medium))
                    .foregroundStyle(Color("P2PTextTertiary"))
                    .frame(
                        width: ChatUIConstants.Composer.sendButtonSize,
                        height: ChatUIConstants.Composer.sendButtonSize
                    )
                    .background(Color("P2PLightGray"))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(trimmedText.isEmpty)
            .opacity(trimmedText.isEmpty ? ChatUIConstants.Composer.sendDisabledOpacity : 1)
        }
        .padding(.horizontal, ChatUIConstants.Composer.horizontalPadding)
        .padding(.top, ChatUIConstants.Composer.topPadding)
        .padding(.bottom, ChatUIConstants.Composer.bottomPadding)
        .background(Color("P2PSurface"))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color("P2PBorder"))
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
