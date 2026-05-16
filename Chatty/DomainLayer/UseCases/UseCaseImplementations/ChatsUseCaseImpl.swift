//
//  ChatsUseCaseImpl.swift
//  Chatty
//
//  Created by Arijit Sarkar on 16/02/26.
//

import Foundation

class ChatsUseCaseImpl: FetchChatUseCase, ObserverChatUpdateUseCase {
    
    private let repository: ChatRepository
    
    init(repository: ChatRepository) {
        self.repository = repository
    }
    
    func fetchChats() async throws -> [ChatEntity] {
        try await repository.fetchChats(before: Date.now.timeIntervalSince1970)
    }
    
    func fetchChats(before: TimeInterval) async throws -> [ChatEntity] {
        try await repository.fetchChats(before: before)
    }
    
    func fetchChats(after: TimeInterval) async throws -> [ChatEntity] {
        try await repository.fetchChats(after: after)
    }
    
    func observe() -> AsyncStream<ChatUpdateEntity> {
        repository.observe()
    }

}
