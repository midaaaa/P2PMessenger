//
//  WirePacket.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation

struct WirePacket: Codable {
    enum Kind: String, Codable {
        case chat
        case hello
    }

    let kind: Kind
    let chat: WireMessage?
    let hello: HelloMessage?

    static func chat(_ message: WireMessage) -> WirePacket {
        WirePacket(kind: .chat, chat: message, hello: nil)
    }

    static func hello(_ message: HelloMessage) -> WirePacket {
        WirePacket(kind: .hello, chat: nil, hello: message)
    }
}
