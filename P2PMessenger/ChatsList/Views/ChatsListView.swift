//
//  ChatsListView.swift
//  P2PMessenger
//
//  Created by Трофим Чекмарев on 01.04.2026.
//

import SwiftUI


// MARK: - ChatsListView

struct ChatsListView: View {
    
    
    private let viewModel: ChatsListViewModel
   
    private let plusButtonAction: () -> Void
    private let chatRowButtonAction: (ChatRowViewModel) -> Void
    
    init(viewModel: ChatsListViewModel,
         
         plusButtonAction: @escaping () -> Void,
         chatRowButtonAction: @escaping (ChatRowViewModel) -> Void) {
        self.viewModel = viewModel
        self.plusButtonAction = plusButtonAction
        self.chatRowButtonAction = chatRowButtonAction
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            chatListView
        }
        .background(Color("P2PLightGray"))
    }

    // MARK: Header

    private var headerView: some View {
        HStack {
            Text(String(localized: "chats_list_title"))
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color("P2PBlack"))
            
            unreadMessagesBadge

            Spacer()

            Button (action: plusButtonAction){
                Image(systemName: "plus")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Color("P2PDarkBlue"))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
    }
    
    private var unreadMessagesBadge: some View {
        Text("\(viewModel.unreadMessagesCount)")
            .font(.body)
            .foregroundStyle(.white)
            .frame(width: 25, height: 25)
            .background(Color("P2PDarkBlue"))
            .clipShape(Circle())
        
    }

    

    
    private var chatListView: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(viewModel.messageChats) { chat in
                    ChatRowView(chat: chat, onTap: { chatRowButtonAction(chat) })
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    let previewStorage = AppKeyValueStorage(defaults: .standard)
    ChatsListView(
        viewModel: ChatsListViewModel(
                coordinator: PeerSessionCoordinator(networkService: MPCNetworkServiceImpl(identityProvider: LocalPeerIdentityProvider(profileStorage: AppProfileStorage(storage: previewStorage))), storage: previewStorage),
                storage: previewStorage
            ),
       
        plusButtonAction: {},
        chatRowButtonAction: { _ in }
    )
}
#endif
