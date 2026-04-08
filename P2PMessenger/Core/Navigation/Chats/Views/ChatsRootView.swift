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
    @Bindable private var appRouter: AppRouter

    init(viewModel: ChatsRootViewModel, router: ChatsRouter, appRouter: AppRouter) {
        self.viewModel = viewModel
        self.router = router
        self.appRouter = appRouter
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
                        appRouter: appRouter,
                        onBack: router.popToRoot
                    )
                    
                    
                    
                }
            }
        }
        .toolbar(router.path.isEmpty ? .visible : .hidden, for: .tabBar)
        .onChange(of: appRouter.activeChatId) { // newValue in
            guard let peerID = appRouter.activeChatId else { return }
            let peer = viewModel.peer(withID: peerID) ?? ChatPeer(id: peerID, displayName: peerID)
            router.popToRoot()
            router.push(.addDialog(peer: peer))
            appRouter.activeChatId = nil
        }
    }
}

// MARK: - Контейнер для @Bindable wiring

private struct PrivateChatView: View {
    @Bindable var viewModel: PrivateChatViewModel
    @Bindable var appRouter: AppRouter
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
        .onAppear {
            appRouter.activeDestination = .private(peerID: viewModel.peer.id)
        }
        .onDisappear {
            if appRouter.activeDestination == .private(peerID: viewModel.peer.id) {
                appRouter.activeDestination = nil
            }
        }
    }
}
