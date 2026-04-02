//
//  TextCard.swift
//  P2PMessenger
//
//  Created by Дмитрий Филимонов on 02.04.2026.
//

import SwiftUI

struct TextCard: View {
    var label: String
    var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(size: Constants.mainFontSize))
                .padding(.bottom, Constants.textCardPadding)
            Text(text)
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding(.vertical, Constants.verticalPadding)
    }
}

private enum Constants {
    static let mainFontSize: CGFloat = 16
    static let textCardPadding: CGFloat = 4
    static let verticalPadding: CGFloat = 6
}

#Preview {
    Group {
        TextCard(label: "Some label text", text: "Really long extra long text")
        TextCard(label: "text", text: "Really long extra long text Really long extra long text Really long extra long text")
    }
    .padding(8)
}
