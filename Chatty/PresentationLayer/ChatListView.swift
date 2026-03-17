//
//  ChatListView.swift
//  Chatty
//
//  Created by Arijit Sarkar on 16/02/26.
//

import SwiftUI

struct ChatListView: View {
    
    @State var chats = [ChatListItemData]()
    @StateObject var viewModel = ChatListViewModelImpl(usecase: ChatsUseCaseImpl(repository: ChatRepositoryImpl()))
    
    var body: some View {
        List(chats) { chat in
            ChatListItemView(chat: chat)
        }
        .onReceive(viewModel.chats) { data in
            chats = data
        }
    }
}

#Preview {
    ChatListView()
}
