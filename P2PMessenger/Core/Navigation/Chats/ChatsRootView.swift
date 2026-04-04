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
                
                
                
                .navigationDestination(for: ChatsRoute.self) { route in
                    switch route {
                    case .dialog:
                        ChatScreenView(configuration: ChatPreviewFixtures.newChat,
                                       draftMessage: .constant(""), onBack: router.popToRoot)
                        .navigationBarBackButtonHidden(true)
                       

                    case .searchDialog:
                        VStack(spacing: 16) {
                            NearbyUsersView(onUserButtonTap: {router.push(.addDialog)})
                            
                        }
                        .navigationTitle("Люди рядом")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(.hidden, for: .tabBar)
                        // AddDialogView()
                    case .addDialog:
                        ChatScreenView(configuration: ChatPreviewFixtures.newChat,
                                       draftMessage: .constant(""), onBack: router.popToRoot)
                        .navigationBarBackButtonHidden(true)
                        
                        
                        
                    }
                }
        }
        .toolbar(router.path.isEmpty ? .visible : .hidden, for: .tabBar)
    }
}
