//
//  ChatsRootView.swift
//  P2PMessenger
//
//  Created by Иван Иванов on 02.04.2026.
//
import SwiftUI

struct ChatsRootView: View {
    private let viewModel: ChatsRootViewModel
    @Bindable private var router: ChatsRouter

    init(viewModel: ChatsRootViewModel, router: ChatsRouter) {
        self.viewModel = viewModel
        self.router = router
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ChatsListView(
                viewModel: viewModel.chatListViewModel,
                plusButtonAction: {router.push(.searchDialog)},
                chatRowButtonAction: {router.push(.dialog)}
            )
            .navigationDestination(for: ChatsRoute.self) { route in
                switch route {
                case .dialog:
                    ChatScreenView(viewModel: viewModel.chatScreenViewModel,
                                   draftMessage: .constant(""), onBack: router.popToRoot)
                    .navigationBarBackButtonHidden(true)
                    
                    
                case .searchDialog:
                    VStack(spacing: 16) {
                        NearbyUsersView(
                            viewModel: viewModel.nearbyUserViewModel,
                            onUserTap: { peer in router.push(.addDialog(peer: peer)) }
                        )
                    }
                    .navigationTitle("Люди рядом")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.hidden, for: .tabBar)

                case .addDialog(let peer):
                    PrivateChatView(
                        viewModel: viewModel.privateChatViewModel(for: peer),
                        onBack: router.popToRoot
                    )
                    
                    
                    
                }
            }
        }
        .toolbar(router.path.isEmpty ? .visible : .hidden, for: .tabBar)
    }
}

// MARK: - Контейнер для @Bindable wiring

private struct PrivateChatView: View {
    @Bindable var viewModel: PrivateChatViewModel
    let onBack: () -> Void

    var body: some View {
        ChatScreenView(
            viewModel: viewModel,
            draftMessage: $viewModel.inputText,
            onBack: onBack,
            onSend: {
                _ in viewModel.sendMessage()
                return true
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}
