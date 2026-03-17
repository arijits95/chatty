//
//  LocalDataSource.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation
import SwiftData

protocol LocalDataSource {
    func saveChats(_ chats: [ChatDTO]) async throws
    func getChats(after: TimeInterval) async throws -> [ChatDTO]
    func deleteAllChats() async throws
}

@ModelActor
actor LocalDataSourceImpl: LocalDataSource {
    
    func saveChats(_ chats: [ChatDTO]) async throws {
        chats
            .map({ $0.toPersistableModel() })
            .forEach { modelContext.insert($0) }
        try modelContext.save()
    }
    
    func getChats(after: TimeInterval) async throws -> [ChatDTO] {
        var fetchDescriptor = FetchDescriptor(
            predicate: #Predicate<ChatDataModel> { $0.lastMessageTimestamp > after },
            sortBy: [SortDescriptor(\ChatDataModel.lastMessageTimestamp, order: .reverse)]
        )
        fetchDescriptor.fetchLimit = 10
        fetchDescriptor.includePendingChanges = false
        return try modelContext
            .fetch(fetchDescriptor, batchSize: 10)
            .map({
                ChatDTO(id: $0.id,
                        participants: [],
                        lastMessage: $0.lastMessage,
                        lastMessageTimestamp: $0.lastMessageTimestamp,
                        isRead: $0.isRead)
            })
    }
    
    func deleteAllChats() async throws {
        try modelContext.delete(model: ChatDataModel.self)
    }
    
}
