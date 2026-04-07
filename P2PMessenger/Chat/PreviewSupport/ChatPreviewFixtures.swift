//
//  ChatPreviewFixtures.swift
//  P2PMessenger
//
//  Created by Anton and Angelina on 02.04.2026.
//

#if DEBUG
import Foundation

enum ChatPreviewFixtures {
    static let newChat: ChatScreenViewModel = {
        let participant = ChatParticipant(name: "Глеб", isOnline: true)
        
        return ChatScreenViewModel.directChat(
            participant: participant,
            subtitle: "Новый чат",
            emptyState: ChatEmptyState(
                participant: participant,
                title: "Глеб",
                subtitle: "Напишите первое сообщение.\nСобеседник получит запрос на чат."
            )
        )
    }()
}
#endif
