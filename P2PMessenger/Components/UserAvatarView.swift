//
//  UserAvatarView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 04.04.2026.
//

import SwiftUI

struct UserAvatarView: View {
    let initial: String
    let statusColor: Color

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(initial)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color("P2PDarkGray"))
                .frame(width: 48, height: 48)
                .background(Color("P2PLightGray"))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("P2PLightGray"), lineWidth: 1))

            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(Color("P2PSurface"), lineWidth: 2))
        }
    }
}
