//
//  ChatsRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//
import SwiftUI

struct ChatsRootView: View {
    @Bindable var router: ChatsRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            Text("Список чатов")
                .navigationTitle("Чаты")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            router.push(.searchDialog)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationDestination(for: ChatsRoute.self) { route in
                    switch route {
                    case .dialog:
                        Text("Личная переписка")
                        // ChatDialogView()

                    case .searchDialog:
                        VStack(spacing: 16) {
                            Text("Найти собеседника")
                            Button("Написать"){
                                router.push(.addDialog)
                            }
                            
                        }
                        .navigationTitle("Люди рядом")
                        .navigationBarTitleDisplayMode(.inline)
                        // AddDialogView()
                    case .addDialog:
                        Text("Отправить запрос на переписку")
                        Button("На главный экран чатов") {
                            router.popToRoot()
                        }
                    }
                }
        }
    }
}
