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
        
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: chatEntity.lastMessageTimestamp)
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "hh:mm a"
            self.lastMessageDateTime = dateFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            self.lastMessageDateTime = "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd/mm/yy"
            self.lastMessageDateTime = dateFormatter.string(from: date)
        }
        
        self.unreadMessageCount = chatEntity.isRead ? 0 : 1
    }
}

protocol ChatListViewModel: ObservableObject {
    var chats: AnyPublisher<[ChatListItemData], Never> { get }
    
    func fetchChats() async
    func didPullToRefresh() async
    func didScrollToBottom()
    func didTapOnChatItem(withId id: String)
}

class ChatListViewModelImpl: ChatListViewModel {
    
    var chats: AnyPublisher<[ChatListItemData], Never>
    
    private var chatListSubject = CurrentValueSubject<[ChatEntity], Never>([])
    private let usecase: any FetchChatUseCase & ObserverChatUpdateUseCase
    private var cancellables: Set<AnyCancellable> = []
    private var stream: Task<Void, Never>?
    
    init(usecase: any FetchChatUseCase & ObserverChatUpdateUseCase) {
        self.usecase = usecase
        chats = chatListSubject
            .map { entities in
                entities.map {
                    ChatListItemData.init(chatEntity: $0)
                }
            }
            .eraseToAnyPublisher()
        Task.detached {
            await self.observeChatUpdate()
        }
    }
    
//    deinit {
//        stream?.cancel()
//    }
    
    private func observeChatUpdate() async {
        for await update in usecase.observe() {
            switch update {
            case .newChat(let chatEntity):
                if let index = chatListSubject.value.firstIndex(where: {
                        chatEntity.lastMessageTimestamp >= $0.lastMessageTimestamp
                }) {
                    chatListSubject.value.insert(chatEntity, at: index)
                }
                else {
                    chatListSubject.value.insert(chatEntity, at: 0)
                }
            case .newMessage(let messageEntity):
                guard let index = chatListSubject.value.firstIndex(where: {
                        messageEntity.chatId >= $0.id
                    })
                else {
                    continue
                }
                chatListSubject.value[index].lastMessage = messageEntity.content
                chatListSubject.value[index].lastMessageTimestamp = messageEntity.createdAt
            default: break
            }
        }
    }
    
    func fetchChats() async {
        do {
            let chats = try await usecase.fetchChats()
            chatListSubject.send(chats)
        } catch {
            
        }
    }
    
    func didPullToRefresh() async  {
        do {
            let chats = try await usecase.fetchChats()
            if !chats.isEmpty {
                chatListSubject.send(chats)
            }
        } catch {
            
        }
    }
    
    func didScrollToBottom() {
        Task {
            if let timestampOfLastChat = chatListSubject.value.last?.lastMessageTimestamp {
                let chats = try await usecase.fetchChats(before: timestampOfLastChat)
                if !chats.isEmpty {
                    let updatedChatList = chatListSubject.value + chats
                    chatListSubject.send(updatedChatList)
                }
            } else {
                
            }
        }
    }
    
    func didTapOnChatItem(withId id: String) {
        // TODO: - Need to take to chat details screen
    }
    
}
