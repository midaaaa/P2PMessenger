//
//  AppRouterProtocol.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import Foundation
import Combine

protocol AppRouterProtocol: AnyObject {
    var selectedTab: AppTab { get set }
    var activeChatId: String? { get set }
    var isAppActive: Bool { get set }
    var activeDestination: ChatDestination? { get set }
    var chatsRouter: ChatsRouter { get }
}
