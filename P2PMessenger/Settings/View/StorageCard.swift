//
//  StorageCard.swift
//  P2PMessenger
//
//  Created by Дмитрий Филимонов on 02.04.2026.
//

import SwiftUI

struct StorageCard: View {
    var formattedSize: String

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.storageIconCornerRadius)
                    .frame(width: Constants.storageIconSize, height: Constants.storageIconSize)
                    .foregroundStyle(.secondary)
                    .opacity(Constants.storageIconOpacity)
                Image(systemName: "server.rack")
            }
            .padding(.trailing, Constants.storageIconPadding)
            VStack(alignment: .leading) {
                Text("spaceTaken")
                Text(String(format: NSLocalizedString("chatsAndMediafiles", comment: ""), formattedSize))
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .padding(.vertical, Constants.verticalPadding)
    }
}

private enum Constants {
    static let storageIconCornerRadius: CGFloat = 20
    static let storageIconSize: CGFloat = 50
    static let storageIconOpacity: CGFloat = 0.2
    static let storageIconPadding: CGFloat = 6

    static let progressViewWidth: CGFloat = 80
    static let progressViewWidthScale: CGFloat = 1
    static let progressViewHeightScale: CGFloat = 1.5

    static let verticalPadding: CGFloat = 6
}

#Preview {
    Group {
        StorageCard(formattedSize: "1.2 MB")
        StorageCard(formattedSize: "512 KB")
        StorageCard(formattedSize: "0 KB")
    }
    .padding(8)
}
