//
//  ChatScreenViewModelProtocol.swift
//  P2PMessenger
//

import Foundation

protocol ChatScreenViewModelProtocol: AnyObject {
    var headerStyle: ChatHeaderStyle { get }
    var timelineTitle: String? { get }
    var messages: [ChatMessage] { get }
    var emptyState: ChatEmptyState? { get }
}
