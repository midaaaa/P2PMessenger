//
//  UserAvatarView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 04.04.2026.
//

import SwiftUI

struct UserAvatarView: View {
    let initial: String
    let isOnline: Bool

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
                .fill(isOnline ? Color("P2PGreen") : Color("P2PDarkGray"))
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(.white, lineWidth: 2))
        }
    }
}
