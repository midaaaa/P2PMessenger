//
//  NearbyUserRowView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 03.04.2026.
//

import SwiftUI

struct NearbyUserRowView: View {
    let user: NearbyUserRowViewModel
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                avatarView
                    .padding(.leading, 14)
                userContent
                    .padding(.leading, 12)
                    .padding(.trailing, 14)
            }
            .frame(height: 78)
            .background(Color("P2PSurface"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("P2PLightGray"), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var statusColor: Color {
        switch user.connectionStatus {
        case .connected:    return Color("P2PGreen")
        case .connecting:   return Color("P2PYellow")
        case .notConnected: return Color("P2PDarkGray")
        }
    }

    private var avatarView: some View {
        UserAvatarView(initial: String(user.name.prefix(1)), statusColor: statusColor)
    }

    private var statusText: String {
        user.connectionStatus.displayName
    }

    private var userContent: some View {
        HStack {
            HStack(spacing: 6) {
                Text(user.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color("P2PDarkBlue"))
                    .lineLimit(1)

                Text(statusText)
                    .font(.system(size: 11))
                    .foregroundStyle(Color("P2PDarkGray"))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color("P2PLightGray"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Spacer()

            HStack(spacing: 8) {
                Image("bluetoothIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(Color("P2PDarkGray"))

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(Color("P2PDarkGray"))
            }
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    NearbyUserRowView(
        user: NearbyUserRowViewModel(id: "preview", name: "Глеб", connectionStatus: .connected),
        onTap: {}
    )
    .padding()
}
#endif
