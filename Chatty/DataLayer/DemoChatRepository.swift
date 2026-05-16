//
//  DemoChatRepository.swift
//  Chatty
//
//  Created by Codex on 16/05/26.
//

import Foundation

final class DemoChatRepository: ChatRepository {
    private let currentUser = UserEntity(
        id: "current-user",
        name: "Arijit",
        profileImage: URL(string: "https://example.com/avatar-current-user.png")!
    )

    private lazy var demoChats: [ChatEntity] = [
        makeChat(id: "chat-1", friendName: "Sukesh", lastMessage: "Can you review the Firebase auth ticket?", minutesAgo: 4, isRead: false),
        makeChat(id: "chat-2", friendName: "Animesh", lastMessage: "The CI workflow is a good first milestone.", minutesAgo: 24, isRead: false),
        makeChat(id: "chat-3", friendName: "Priya", lastMessage: "Media upload progress should feel instant.", minutesAgo: 60 * 5, isRead: true),
        makeChat(id: "chat-4", friendName: "Chatty Design Group", lastMessage: "Let us keep the first release focused.", minutesAgo: 60 * 26, isRead: true),
        makeChat(id: "chat-5", friendName: "Rohan", lastMessage: "Typing indicators can wait until M4.", minutesAgo: 60 * 72, isRead: true)
    ].sortedByRecentMessage()

    func fetchChats(before timestamp: TimeInterval) async throws -> [ChatEntity] {
        demoChats
            .filter { $0.lastMessageTimestamp < timestamp }
            .sortedByRecentMessage()
            .prefix(10)
            .map { $0 }
    }

    func fetchChats(after timestamp: TimeInterval) async throws -> [ChatEntity] {
        demoChats
            .filter { $0.lastMessageTimestamp > timestamp }
            .sortedByRecentMessage()
    }

    func observe() -> AsyncStream<ChatUpdateEntity> {
        AsyncStream { continuation in
            let task = Task {
                try? await Task.sleep(nanoseconds: 500_000_000)
                continuation.yield(.newMessage(
                    MessageEntity(
                        id: "message-demo-update",
                        chatId: "chat-1",
                        senderId: "friend-chat-1",
                        receiverId: currentUser.id,
                        content: "Demo backend is now explicit and swappable.",
                        status: .delivered,
                        createdAt: Date.now.timeIntervalSince1970
                    )
                ))
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    private func makeChat(
        id: String,
        friendName: String,
        lastMessage: String,
        minutesAgo: TimeInterval,
        isRead: Bool
    ) -> ChatEntity {
        ChatEntity(
            id: id,
            participants: [
                UserEntity(
                    id: "friend-\(id)",
                    name: friendName,
                    profileImage: URL(string: "https://example.com/avatar-\(id).png")!
                ),
                currentUser
            ],
            lastMessage: lastMessage,
            lastMessageTimestamp: Date.now.addingTimeInterval(-minutesAgo * 60).timeIntervalSince1970,
            isRead: isRead
        )
    }
}
