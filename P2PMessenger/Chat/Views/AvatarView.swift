//
//  AvatarView.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

import SwiftUI

struct AvatarView: View {
    let image: Image?
    let initial: String
    let isOnline: Bool
    let size: CGFloat

    init(
        image: Image? = nil,
        initial: String,
        isOnline: Bool,
        size: CGFloat = 48
    ) {
        self.image = image
        self.initial = initial
        self.isOnline = isOnline
        self.size = size
    }

    var body: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.p2pBorder)
                    .frame(width: size, height: size)
                    .overlay {
                        Text(initial)
                            .font(.system(size: size * 0.42, weight: .medium))
                            .foregroundStyle(Color.p2pTextSecondary)
                    }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Circle()
                .fill(statusColor)
                .frame(width: size * 0.24, height: size * 0.24)
                .overlay {
                    Circle()
                        .stroke(Color.p2pSurface, lineWidth: size * 0.05)
                }
                .padding(size * 0.03)
        }
    }

    private var statusColor: Color {
        isOnline ? Color.p2pTextSecondary : Color.p2pBorder
    }
}
