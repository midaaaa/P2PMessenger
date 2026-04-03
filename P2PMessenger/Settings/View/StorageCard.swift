//
//  StorageCard.swift
//  P2PMessenger
//
//  Created by Дмитрий Филимонов on 02.04.2026.
//

import SwiftUI

struct StorageCard: View {
    var size: Int
    @Binding var progress: Double

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
                Text(LocalizedStringResource("chatsAndMediafiles", defaultValue: "\(size)"))  // compute size units
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            Spacer()
            ProgressView(value: progress)
                .scaleEffect(x: Constants.progressViewWidthScale,
                             y: Constants.progressViewHeightScale)
                .tint(.secondary)
                .frame(maxWidth: Constants.progressViewWidth)
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
        StorageCard(size: 1000, progress: Binding.constant(0.5))
        StorageCard(size: 0, progress: Binding.constant(0))
        StorageCard(size: 12345, progress: Binding.constant(1))
    }
    .padding(8)
}
