//
//  AvatarView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct AvatarView: View {
    let initial: String
    let isOnline: Bool
    let size: CGFloat

    init(
        initial: String,
        isOnline: Bool,
        size: CGFloat = 48
    ) {
        self.initial = initial
        self.isOnline = isOnline
        self.size = size
    }

    var body: some View {
        Circle()
            .fill(Color("P2PBorder"))
            .frame(width: size, height: size)
            .overlay {
                Text(initial)
                    .font(.system(size: size * 0.42, weight: .medium))
                    .foregroundStyle(Color("P2PTextSecondary"))
            }
        .overlay(alignment: .bottomTrailing) {
            Circle()
                .fill(statusColor)
                .frame(width: size * 0.24, height: size * 0.24)
                .overlay {
                    Circle()
                        .stroke(Color("P2PSurface"), lineWidth: size * 0.05)
                }
                .padding(size * 0.03)
        }
    }

    private var statusColor: Color {
        isOnline ? Color.p2PGreen : Color.p2PDarkGray
    }
}

#Preview {
    Group {
        AvatarView(initial: "P", isOnline: true, size: 100)
        AvatarView(initial: "M", isOnline: false, size: 100)
    }
}
