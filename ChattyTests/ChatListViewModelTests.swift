//
//  ChatListViewModelTests.swift
//  ChattyTests
//
//  Created by Codex on 16/05/26.
//

import Combine
internal import Foundation
import Testing
@testable import Chatty

@MainActor
struct ChatListViewModelTests {
    @Test func fetchChatsPublishesRecentChatsFirst() async throws {
        let olderChat = makeChat(id: "older", timestamp: 100)
        let newerChat = makeChat(id: "newer", timestamp: 200)
        let viewModel = ChatListViewModelImpl(
            usecase: MockChatUseCase(chats: [olderChat, newerChat])
        )
        let recorder = PublisherRecorder(viewModel.chats)

        await viewModel.fetchChats()

        let chats = recorder.latestValue ?? []
        #expect(chats.map(\.id) == ["newer", "older"])
    }

    @Test func fetchChatsPublishesEmptyStateWhenNoChatsExist() async throws {
        let viewModel = ChatListViewModelImpl(usecase: MockChatUseCase(chats: []))
        let recorder = PublisherRecorder(viewModel.state)

        await viewModel.fetchChats()

        #expect(recorder.latestValue == .empty)
    }

    @Test func chatListItemUsesUnreadCountForUnreadChats() {
        let unread = ChatListItemData(chatEntity: makeChat(id: "unread", isRead: false))
        let read = ChatListItemData(chatEntity: makeChat(id: "read", isRead: true))

        #expect(unread.unreadMessageCount == 1)
        #expect(read.unreadMessageCount == 0)
    }
}

private final class MockChatUseCase: FetchChatUseCase, ObserverChatUpdateUseCase {
    private let chats: [ChatEntity]

    init(chats: [ChatEntity]) {
        self.chats = chats
    }

    func fetchChats() async throws -> [ChatEntity] {
        chats
    }

    func fetchChats(before: TimeInterval) async throws -> [ChatEntity] {
        chats.filter { $0.lastMessageTimestamp < before }
    }

    func fetchChats(after: TimeInterval) async throws -> [ChatEntity] {
        chats.filter { $0.lastMessageTimestamp > after }
    }

    func observe() -> AsyncStream<ChatUpdateEntity> {
        AsyncStream { continuation in
            continuation.finish()
        }
    }
}

private final class PublisherRecorder<Value> {
    private var cancellable: AnyCancellable?
    private(set) var latestValue: Value?

    init(_ publisher: AnyPublisher<Value, Never>) {
        cancellable = publisher.sink { [weak self] value in
            self?.latestValue = value
        }
    }
}

private func makeChat(id: String, timestamp: TimeInterval = 100, isRead: Bool = true) -> ChatEntity {
    ChatEntity(
        id: id,
        participants: [
            UserEntity(
                id: "friend-\(id)",
                name: "Friend \(id)",
                profileImage: URL(string: "https://example.com/\(id).png")!
            )
        ],
        lastMessage: "Message \(id)",
        lastMessageTimestamp: timestamp,
        isRead: isRead
    )
}
