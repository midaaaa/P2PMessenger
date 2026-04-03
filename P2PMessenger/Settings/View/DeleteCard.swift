//
//  DeleteCard.swift
//  P2PMessenger
//
//  Created by Дмитрий Филимонов on 02.04.2026.
//

import SwiftUI

struct DeleteCard: View {
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.deleteIconCornerRadius)
                    .frame(width: Constants.deleteIconSize, height: Constants.deleteIconSize)
                    .foregroundStyle(.secondary)
                    .opacity(Constants.deleteIconOpacity)
                Image(systemName: "trash")
            }
            .padding(.trailing, Constants.deleteIconPadding)
            Text(.removeAllChats)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .tint(.primary)
        .padding(.vertical, Constants.verticalPadding)
    }
}

private enum Constants {
    static let deleteIconCornerRadius: CGFloat = 20
    static let deleteIconSize: CGFloat = 50
    static let deleteIconOpacity: CGFloat = 0.2
    static let deleteIconPadding: CGFloat = 6

    static let verticalPadding: CGFloat = 6
}

#Preview {
    DeleteCard()
        .padding(8)
}
