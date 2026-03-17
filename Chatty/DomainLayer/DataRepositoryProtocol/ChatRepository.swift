//
//  ChatRepository.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

protocol ChatRepository {
    func fetchChats(before: TimeInterval) async throws -> [ChatEntity]
    func fetchChats(after: TimeInterval) async throws -> [ChatEntity]
    func observe() -> AsyncStream<ChatUpdateEntity>
}
