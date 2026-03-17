//
//  FetchChatUseCase.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

protocol FetchChatUseCase {
    func fetchChats() async throws -> [ChatEntity]
    func fetchChats(before: TimeInterval) async throws -> [ChatEntity]
    func fetchChats(after: TimeInterval) async throws -> [ChatEntity]
}

