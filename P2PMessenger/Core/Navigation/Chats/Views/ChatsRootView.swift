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
    private let appRouter: any AppRouterProtocol

    init(viewModel: ChatsRootViewModel, router: ChatsRouter, appRouter: any AppRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        self.appRouter = appRouter
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ChatsListView(
                viewModel: viewModel.chatListViewModel,
                plusButtonAction: {router.push(.searchDialog)},
                chatRowButtonAction: { chat in
                    let peer = viewModel.peer(withID: chat.id) ?? ChatPeer(id: chat.id, displayName: chat.name)
                    router.push(.addDialog(peer: peer))
                }
            )
            .navigationDestination(for: ChatsRoute.self) { route in
                switch route {
                case .searchDialog:
                    VStack(spacing: 16) {
                        NearbyUsersView(
                            viewModel: viewModel.nearbyUserViewModel,
                            onUserTap: { peer in router.push(.addDialog(peer: peer)) }
                        )
                    }
                    .navigationTitle("peopleNearby")
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
    let appRouter: any AppRouterProtocol
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
