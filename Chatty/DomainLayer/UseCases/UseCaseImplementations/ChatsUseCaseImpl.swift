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
        try await repository.fetchChats(before: Date.now.timeIntervalSinceNow)
    }
    
    func fetchChats(before: TimeInterval) async throws -> [ChatEntity] {
        try await repository.fetchChats(before: before)
    }
    
    func fetchChats(after: TimeInterval) async throws -> [ChatEntity] {
        try await repository.fetchChats(before: after)
    }
    
    func observe() -> AsyncStream<ChatUpdateEntity> {
        repository.observe()
    }

}
