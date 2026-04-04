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

    static let publicChat: ChatScreenViewModel = {
        let vasya = ChatParticipant(name: "Вася", isOnline: true)
        let masha = ChatParticipant(name: "Маша", isOnline: true)
        let gleb = ChatParticipant(name: "Глеб", isOnline: true)

        return ChatScreenViewModel.groupChat(
            title: "Общий чат",
            participantsSubtitle: "5 участников",
            messages: [
                ChatMessage(
                    sender: .incoming(vasya),
                    text: "Всем привет! Кто сегодня в парке?",
                    time: "11:02"
                ),
                ChatMessage(
                    sender: .incoming(masha),
                    text: "Я буду после 15:00",
                    time: "11:04"
                ),
                ChatMessage(
                    sender: .outgoing,
                    text: "Отлично, тогда встречаемся у фонтана 🙂",
                    time: "11:05"
                ),
                ChatMessage(
                    sender: .incoming(gleb),
                    text: "Я тоже подойду! Возьмите термос",
                    time: "11:07"
                ),
                ChatMessage(
                    sender: .incoming(vasya),
                    text: "Хорошая идея 👍",
                    time: "11:09"
                )
            ],
            timelineTitle: "Сегодня · Общий чат"
        )
    }()
}
#endif
