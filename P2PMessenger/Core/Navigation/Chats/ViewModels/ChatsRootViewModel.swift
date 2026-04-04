//
//  ChatsRootViewModel.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 04.04.2026.
//
import SwiftUI

@Observable
final class ChatsRootViewModel{
    let chatListViewModel: ChatsListViewModel

    let chatScreenViewModel: ChatScreenViewModel
    
    init(chatListViewModel: ChatsListViewModel, chatScreenViewModel: ChatScreenViewModel) {
        self.chatListViewModel = chatListViewModel
        self.chatScreenViewModel = chatScreenViewModel
    }
}
