//
//  ChatListViewModel.swift
//  Chatty
//
//  Created by Arijit Sarkar on 16/02/26.
//

import Foundation
import Combine

struct ChatListItemData: Identifiable {
    let id: String
    let name: String
    let lastMessage: String
    let lastMessageDateTime: String
    let unreadMessageCount: Int
}

extension ChatListItemData {
    
    init(chatEntity: ChatEntity) {
        self.id = chatEntity.id
        self.name = chatEntity.participants.first?.name ?? ""
        self.lastMessage = chatEntity.lastMessage
        self.lastMessageDateTime = ChatListItemData.formattedTimestamp(chatEntity.lastMessageTimestamp)
        self.unreadMessageCount = chatEntity.isRead ? 0 : 1
    }

    static func formattedTimestamp(_ timestamp: TimeInterval, calendar: Calendar = .current) -> String {
        let date = Date(timeIntervalSince1970: timestamp)

        if calendar.isDateInToday(date) {
            return date.formatted(date: .omitted, time: .shortened)
        }

        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        return date.formatted(.dateTime.day().month().year(.twoDigits))
    }
}

protocol ChatListViewModel: ObservableObject {
    var chats: AnyPublisher<[ChatListItemData], Never> { get }
    var state: AnyPublisher<ChatListState, Never> { get }
    
    func fetchChats() async
    func didPullToRefresh() async
    func didScrollToBottom()
    func didTapOnChatItem(withId id: String)
}

enum ChatListState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case failed(String)
}

class ChatListViewModelImpl: ChatListViewModel {
    
    var chats: AnyPublisher<[ChatListItemData], Never>
    var state: AnyPublisher<ChatListState, Never>
    
    private var chatListSubject = CurrentValueSubject<[ChatEntity], Never>([])
    private let stateSubject = CurrentValueSubject<ChatListState, Never>(.idle)
    private let usecase: any FetchChatUseCase & ObserverChatUpdateUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    init(usecase: any FetchChatUseCase & ObserverChatUpdateUseCase) {
        self.usecase = usecase
        chats = chatListSubject
            .map { entities in
                entities.sortedByRecentMessage().map {
                    ChatListItemData.init(chatEntity: $0)
                }
            }
            .eraseToAnyPublisher()
        state = stateSubject.eraseToAnyPublisher()

        Task {
            await self.observeChatUpdate()
        }
    }

    private func observeChatUpdate() async {
        for await update in usecase.observe() {
            switch update {
            case .newChat(let chatEntity):
                upsertChat(chatEntity)
            case .newMessage(let messageEntity):
                guard let index = chatListSubject.value.firstIndex(where: { $0.id == messageEntity.chatId }) else {
                    continue
                }
                chatListSubject.value[index].lastMessage = messageEntity.content
                chatListSubject.value[index].lastMessageTimestamp = messageEntity.createdAt
                chatListSubject.value[index].isRead = false
                chatListSubject.send(chatListSubject.value.sortedByRecentMessage())
            default: break
            }
        }
    }

    private func upsertChat(_ chat: ChatEntity) {
        var chats = chatListSubject.value
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index] = chat
        } else {
            chats.append(chat)
        }
        chatListSubject.send(chats.sortedByRecentMessage())
        stateSubject.send(chats.isEmpty ? .empty : .loaded)
    }
    
    func fetchChats() async {
        stateSubject.send(.loading)
        do {
            let chats = try await usecase.fetchChats().sortedByRecentMessage()
            chatListSubject.send(chats)
            stateSubject.send(chats.isEmpty ? .empty : .loaded)
        } catch {
            stateSubject.send(.failed("Unable to load chats. Pull to refresh and try again."))
        }
    }
    
    func didPullToRefresh() async  {
        do {
            let chats = try await usecase.fetchChats().sortedByRecentMessage()
            if !chats.isEmpty {
                chatListSubject.send(chats)
                stateSubject.send(.loaded)
            }
        } catch {
            stateSubject.send(.failed("Refresh failed. Please try again."))
        }
    }
    
    func didScrollToBottom() {
        Task {
            if let timestampOfLastChat = chatListSubject.value.last?.lastMessageTimestamp {
                let chats = try await usecase.fetchChats(before: timestampOfLastChat)
                if !chats.isEmpty {
                    let updatedChatList = (chatListSubject.value + chats).sortedByRecentMessage()
                    chatListSubject.send(updatedChatList)
                }
            }
        }
    }
    
    func didTapOnChatItem(withId id: String) {
        // TODO: - Need to take to chat details screen
    }
    
}
