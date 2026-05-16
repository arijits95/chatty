//
//  ChatListView.swift
//  Chatty
//
//  Created by Arijit Sarkar on 16/02/26.
//

import SwiftUI

struct ChatListView: View {
    
    @State var chats = [ChatListItemData]()
    @State private var state: ChatListState = .idle
    @StateObject var viewModel: ChatListViewModelImpl

    init(viewModel: ChatListViewModelImpl) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch state {
                case .idle, .loading:
                    ProgressView("Loading chats")
                case .empty:
                    ContentUnavailableView(
                        "No Chats Yet",
                        systemImage: "message",
                        description: Text("Start a direct or group conversation to see it here.")
                    )
                case .failed(let message):
                    ContentUnavailableView(
                        "Could Not Load Chats",
                        systemImage: "exclamationmark.triangle",
                        description: Text(message)
                    )
                case .loaded:
                    List(chats) { chat in
                        Button {
                            viewModel.didTapOnChatItem(withId: chat.id)
                        } label: {
                            ChatListItemView(chat: chat)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            if chat.id == chats.last?.id {
                                viewModel.didScrollToBottom()
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.didPullToRefresh()
                    }
                }
            }
            .navigationTitle("Chatty")
        }
        .onReceive(viewModel.chats) { data in
            chats = data
        }
        .onReceive(viewModel.state) { data in
            state = data
        }
        .task {
            await viewModel.fetchChats()
        }
    }
}

#Preview {
    ChatListView(viewModel: AppDependencies().makeChatListViewModel())
}
