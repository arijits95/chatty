//
//  ChatDTO.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

struct ChatDTO {
    var id: String
    var participants: [UserDTO]
    var lastMessage: String
    var lastMessageTimestamp: TimeInterval
    var isRead: Bool
}

extension ChatDTO {
    
    func toDomain() -> ChatEntity {
        .init(id: id,
              participants: participants.map({$0.toDomain()}),
              lastMessage: lastMessage,
              lastMessageTimestamp: lastMessageTimestamp,
              isRead: isRead)
    }
}

extension ChatDTO {
    
    nonisolated func toPersistableModel() -> ChatDataModel {
        .init(id: id,
              participants: participants.map({$0.id}),
              lastMessage: lastMessage,
              lastMessageTimestamp: lastMessageTimestamp,
              isRead: isRead)
    }
}
