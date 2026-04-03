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
            ChatsListView(
                plusButtonAction: {router.push(.searchDialog)},
                chatRowButtonAction: {router.push(.dialog)}
            )
                .navigationTitle("Чаты")
                
                
                .navigationDestination(for: ChatsRoute.self) { route in
                    switch route {
                    case .dialog:
                        ChatScreenView(configuration: ChatPreviewFixtures.newChat,
                                       draftMessage: .constant(""), onBack: router.popToRoot)
                        .navigationBarBackButtonHidden(true)
                       

                    case .searchDialog:
                        VStack(spacing: 16) {
                            Text("Найти собеседника")
                            Button("Написать"){
                                router.push(.addDialog)
                            }
                            
                        }
                        .navigationTitle("Люди рядом")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(.hidden, for: .tabBar)
                        // AddDialogView()
                    case .addDialog:
                        Text("Отправить запрос на переписку")
                        Button("На главный экран чатов") {
                            router.popToRoot()
                        }
                        
                    }
                }
        }
        .toolbar(router.path.isEmpty ? .visible : .hidden, for: .tabBar)
    }
}
