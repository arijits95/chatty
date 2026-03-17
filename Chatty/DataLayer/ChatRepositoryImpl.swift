//
//  ChatRepositoryImpl.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

class ChatRepositoryImpl: ChatRepository {
    
    init(remoteDataSource: RemoteDataSource, localDataSource: LocalDataSource) {
        
    }
    
    init() {
        
    }
    
    func fetchChats(before: TimeInterval) async throws -> [ChatEntity] {
        return []
    }
    
    func fetchChats(after: TimeInterval) async throws -> [ChatEntity] {
        return []
    }
    
    func observe() -> AsyncStream<ChatUpdateEntity> {
        return AsyncStream { continuation  in
            Task {
                for i in 1...10 {
                    try await Task.sleep(nanoseconds: 100_000_000)
//                    if i.isMultiple(of: 20) {
                        let chat = ChatEntity(id: "\(i)",
                                              participants: [UserEntity(id: "\(i)", name: "Friend \(i)", profileImage: URL(string: "https://via.placeholder.com/150")!),
                                                             UserEntity(id: "1", name: "Arijit", profileImage: URL(string: "https://via.placeholder.com/150")!),
                                                            ],
                                              lastMessage: "message \(i)",
                                              lastMessageTimestamp: Date.now.timeIntervalSince1970,
                                              isRead: false)
                        continuation.yield(ChatUpdateEntity.newChat(chat))
//                    } else {
//                        let chatdId = [20, 40, 60, 80, 100].randomElement() ?? 60
//                        let senderId = "Friend \(chatdId)"
//                        let message = MessageEntity(id: "\(i)",
//                                                    chatId: "\(chatdId)",
//                                                    senderId: senderId,
//                                                    receiverId: "1",
//                                                    content: "message \(i)",
//                                                    status: .delivered,
//                                                    createdAt: Date.now.addingTimeInterval(Double(60 * i)).timeIntervalSince1970)
//                        continuation.yield(ChatUpdateEntity.newMessage(message))
//                    }
                }
                continuation.finish()
            }
        }
    }
}



